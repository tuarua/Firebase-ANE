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
    private var modelOptions: ModelOptions?
    private var isStatsCollectionEnabled = true
    private let userInitiatedQueue = DispatchQueue(label: "com.tuarua.vision.tfl.uiq", qos: .userInitiated)
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let options = ModelOptions(argv[0]),
            let isStatsCollectionEnabled = Bool(argv[1])
            else {
                return FreArgError(message: "run").getError(#file, #line, #column)
        }
        modelOptions = options
        self.isStatsCollectionEnabled = isStatsCollectionEnabled
        return true.toFREObject()
    }
    
    func registerCloudModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let modelSource = CloudModelSource(argv[0])
            else {
                return FreArgError(message: "registerCloudModel").getError(#file, #line, #column)
        }
        return ModelManager.modelManager().register(modelSource).toFREObject()
    }
    
    func registerLocalModel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let modelSource = LocalModelSource(argv[0])
            else {
                return FreArgError(message: "registerLocalModel").getError(#file, #line, #column)
        }
        return ModelManager.modelManager().register(modelSource).toFREObject()
    }
    
    func cloudModelSource(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let name = String(argv[0])
            else {
                return FreArgError(message: "cloudModelSource").getError(#file, #line, #column)
        }
        return ModelManager.modelManager().cloudModelSource(forModelName: name)?.name.toFREObject()
    }
    
    func localModelSource(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let name = String(argv[0])
            else {
                return FreArgError(message: "localModelSource").getError(#file, #line, #column)
        }
        return ModelManager.modelManager().localModelSource(forModelName: name)?.name.toFREObject()
    }
        
    func run(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let modelInputs = ModelInputs.init(argv[0]),
            let options = ModelInputOutputOptions(argv[1]),
            let maxResults = Int(argv[2]),
            let numPossibilities = Int(argv[3]),
            let eventId = String(argv[4]),
            let modelOptions = modelOptions
            else {
                return FreArgError(message: "run").getError(#file, #line, #column)
        }
        
        let interpreter = ModelInterpreter.modelInterpreter(options: modelOptions)
        interpreter.isStatsCollectionEnabled = isStatsCollectionEnabled
        
        userInitiatedQueue.async {
            interpreter.run(inputs: modelInputs, options: options) { (outputs, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: ModelInterpreterEvent.OUTPUT,
                                       value: ModelInterpreterEvent(eventId: eventId,
                                                                    error: err).toJSONString())
                } else {
                    var arrProps = [[String: Any]]()
                    if let outputs = outputs {
                        let probabilities = try? outputs.output(index: 0) as? [[NSNumber]]
                        if let first = probabilities??.first {
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
            }
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
