/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import Foundation
import FreSwift
import FirebaseMLCommon
import FirebaseMLModelInterpreter

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var isStatsCollectionEnabled = true
    private let userInitiatedQueue = DispatchQueue(label: "com.tuarua.vision.tfl.uiq", qos: .userInitiated)
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let isStatsCollectionEnabled = Bool(argv[1])
            else {
                return FreArgError().getError()
        }
        self.isStatsCollectionEnabled = isStatsCollectionEnabled
        return true.toFREObject()
    }
    
    func isModelDownloaded(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let remoteModel = CustomRemoteModel(argv[0])
            else {
                return FreArgError().getError()
        }
        return ModelManager.modelManager().isModelDownloaded(remoteModel).toFREObject()
    }
    
    func deleteDownloadedModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let remoteModel = CustomRemoteModel(argv[0])
            else {
                return FreArgError().getError()
        }
        ModelManager.modelManager().deleteDownloadedModel(remoteModel) { (error) in
            // TODO
        }
        return nil
    }
    
    func download(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let model = CustomRemoteModel(argv[0]),
            let conditions = ModelDownloadConditions(argv[1])
            else {
                return FreArgError().getError()
        }
        
        NotificationCenter.default.addObserver(
            forName: .firebaseMLModelDownloadDidSucceed,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let _ = self,
                let userInfo = notification.userInfo,
                let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue]
                    as? RemoteModel,
                model.name == "your_remote_model"
                else { return }
            // The model was downloaded and is available on the device
        }
        ModelManager.modelManager().download(model, conditions: conditions)
        return nil
    }

    func run(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let modelInputs = ModelInputs.init(argv[0]),
            let options = ModelInputOutputOptions(argv[1]),
            let maxResults = Int(argv[2]),
            let numPossibilities = Int(argv[3]),
            let eventId = String(argv[4]),
            let interpreterOptions = FREObject(argv[5])
            else {
                return FreArgError().getError()
        }
        var interpreter: ModelInterpreter?
        if let localModel = CustomLocalModel.init(interpreterOptions["localModel"]) {
            interpreter = ModelInterpreter.modelInterpreter(localModel: localModel)
        }
        if let remoteModel = CustomRemoteModel(interpreterOptions["remoteModel"]) {
            interpreter = ModelInterpreter.modelInterpreter(remoteModel: remoteModel)
        }
    
        interpreter?.isStatsCollectionEnabled = isStatsCollectionEnabled
        userInitiatedQueue.async {
            interpreter?.run(inputs: modelInputs, options: options, completion: { (outputs, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: ModelInterpreterEvent.OUTPUT,
                                       value: ModelInterpreterEvent(eventId: eventId,
                                                                    error: err).toJSONString())
                } else {
                    var arrProps = [[String: Any]]()
                    if let outputs = outputs {
                        let probabilities = try? outputs.output(index: 0) as? [[NSNumber]]
                        if let first = probabilities?.first {
                            let confidences = first.map { quantizedValue in
                                Softmax.scale * Float(quantizedValue.intValue - Softmax.zeroPoint)
                            }
                            let zippedResults = zip(0...(numPossibilities-1), confidences)
                            let sortedResults = zippedResults.sorted { $0.1 > $1.1 }.prefix(maxResults)
                            for item in sortedResults {
                                var d = [String: Any]()
                                d["index"] = item.0
                                d["confidence"] = item.1
                                arrProps.append(d)
                            }
                        }
                    }
                    self.dispatchEvent(name: ModelInterpreterEvent.OUTPUT,
                                       value: ModelInterpreterEvent(eventId: eventId,
                                                                    data: arrProps).toJSONString())
                }
            })
        }
        return nil
    }
}

// MARK: - Internal

/// Default quantization parameters for Softmax. The Softmax function is normally implemented as the
/// final layer, just before the output layer, of a neural-network based classifier.
///
/// Quantized values can be mapped to float values using the following conversion:
///   `realValue = scale * (quantizedValue - zeroPoint)`.
enum Softmax {
    static let zeroPoint: Int = 0
    static var scale: Float { return Float(1.0 / (maxUInt8QuantizedValue + normalizerValue)) }
    
    // MARK: - Private
    
    private static let maxUInt8QuantizedValue = 255.0
    private static let normalizerValue = 1.0
}
