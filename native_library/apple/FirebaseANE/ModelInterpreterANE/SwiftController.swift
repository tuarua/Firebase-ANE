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
import Firebase

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
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
    
    func run(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let options = ModelOptions(argv[0]),
            let inputs = ModelInputs(argv[1]),
            let runOptions = ModelInputOutputOptions(argv[2]),
            let eventId = String(argv[3])
            else {
                return FreArgError(message: "run").getError(#file, #line, #column)
        }
        
        let interpreter = ModelInterpreter.modelInterpreter(options: options)
        interpreter.run(inputs: inputs, options: runOptions) { (outputs, error) in
            if let err = error as NSError? {
                self.dispatchEvent(name: ModelInterpreterEvent.OUTPUT,
                                   value: ModelInterpreterEvent(eventId: eventId,
                                                        error: ["text": err.localizedDescription,
                                                                "id": err.code]).toJSONString())
            } else {
                if let outputs = outputs {
                    self.trace(outputs.debugDescription)
                    let probabilities = try? outputs.output(index: 0)
                }
            }
        }
        return nil
    }

}
