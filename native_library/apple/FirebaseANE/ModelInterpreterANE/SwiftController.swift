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
    private var downloadCallbacks = [String: String]()
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let isStatsCollectionEnabled = Bool(argv[1])
            else {
                return FreArgError().getError()
        }
        self.isStatsCollectionEnabled = isStatsCollectionEnabled
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(remoteModelDownloadDidSucceed(_:)),
          name: .firebaseMLModelDownloadDidSucceed,
          object: nil
        )
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(remoteModelDownloadDidFail(_:)),
          name: .firebaseMLModelDownloadDidFail,
          object: nil
        )
        
        return true.toFREObject()
    }
    
    func isModelDownloaded(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let model = CustomRemoteModel(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        self.dispatchEvent(name: ModelInterpreterEvent.IS_DOWNLOADED,
                           value: ModelInterpreterEvent(callbackId: callbackId,
                                                        result: ModelManager.modelManager().isModelDownloaded(model))
                            .toJSONString())
        return nil
    }
    
    func deleteDownloadedModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let remoteModel = CustomRemoteModel(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        ModelManager.modelManager().deleteDownloadedModel(remoteModel) { (error) in
            self.dispatchEvent(name: ModelInterpreterEvent.DELETE_DOWNLOADED,
            value: ModelInterpreterEvent(callbackId: callbackId,
                                         result: error == nil)
             .toJSONString())
        }
        return nil
    }
    
    func download(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let model = CustomRemoteModel(argv[0]),
            let conditions = ModelDownloadConditions(argv[1]),
            let callbackId = String(argv[2])
            else {
                return FreArgError().getError()
        }
        downloadCallbacks[model.name] = callbackId
        ModelManager.modelManager().download(model, conditions: conditions)
        return nil
    }

    func run(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let modelInputs = ModelInputs(argv[0]),
            let options = ModelInputOutputOptions(argv[1]),
            let maxResults = Int(argv[2]),
            let numPossibilities = Int(argv[3]),
            let callbackId = String(argv[4]),
            let interpreterOptions = FREObject(argv[5])
            else {
                return FreArgError().getError()
        }
        var interpreter: ModelInterpreter?
        if let localModel = CustomLocalModel(interpreterOptions["localModel"]) {
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
                                       value: ModelInterpreterEvent(callbackId: callbackId,
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
                                       value: ModelInterpreterEvent(callbackId: callbackId,
                                                                    data: arrProps).toJSONString())
                }
            })
        }
        return nil
    }
    
    // MARK: - Notifications

    @objc
    private func remoteModelDownloadDidSucceed(_ notification: Notification) {
      let notificationHandler = {
        guard let userInfo = notification.userInfo,
          let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? RemoteModel
        else { return }
        self.dispatchEvent(name: ModelInterpreterEvent.DOWNLOAD,
        value: ModelInterpreterEvent(callbackId: self.downloadCallbacks[model.name]).toJSONString())
      }
      if Thread.isMainThread {
        notificationHandler()
        return
      }
      DispatchQueue.main.async { notificationHandler() }
    }
    
    @objc
    private func remoteModelDownloadDidFail(_ notification: Notification) {
      let notificationHandler = {
        guard let userInfo = notification.userInfo,
          let model = userInfo[ModelDownloadUserInfoKey.remoteModel.rawValue] as? RemoteModel,
          let err = userInfo[ModelDownloadUserInfoKey.error.rawValue] as? NSError
        else { return }
        self.dispatchEvent(name: ModelInterpreterEvent.DOWNLOAD,
                           value: ModelInterpreterEvent(callbackId: self.downloadCallbacks[model.name],
                                                        error: err).toJSONString())
      }
      if Thread.isMainThread { notificationHandler();return }
      DispatchQueue.main.async { notificationHandler() }
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
