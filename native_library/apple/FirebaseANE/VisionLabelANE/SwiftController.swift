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
import FirebaseMLVision

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private let userInitiatedQueue = DispatchQueue(label: "com.tuarua.vision.lbl.uiq", qos: .userInitiated)
    private var results: [String: [VisionLabel?]] = [:]
    private var labelDetector: VisionLabelDetector?
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let options = VisionLabelDetectorOptions(argv[0])
            else {
                return FreArgError(message: "initController").getError(#file, #line, #column)
        }
        labelDetector = Vision.vision().labelDetector(options: options)
        return true.toFREObject()
    }
    
    func detect(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let image = VisionImage(argv[0]),
            let eventId = String(argv[1])
            else {
                return FreArgError(message: "detect").getError(#file, #line, #column)
        }
        userInitiatedQueue.async {
            self.labelDetector?.detect(in: image) { (result, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: LabelEvent.RECOGNIZED,
                                       value: LabelEvent(eventId: eventId, error: err).toJSONString()
                    )
                } else {
                    if let result = result, !result.isEmpty {
                        self.results[eventId] = result
                        self.dispatchEvent(name: LabelEvent.RECOGNIZED,
                                           value: LabelEvent(eventId: eventId).toJSONString())
                    }
                }
            }
        }
        return nil
    }
    
    func getResults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError(message: "getResults").getError(#file, #line, #column)
        }
        let ret = results[eventId]?.toFREObject()
        results[eventId] = nil
        return ret
    }
    
    func close(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
}
