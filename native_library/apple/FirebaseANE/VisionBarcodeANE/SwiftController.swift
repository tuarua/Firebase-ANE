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
    private var results: [String: [VisionBarcode?]] = [:]
    lazy var vision = Vision.vision()
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func detect(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let image = VisionImage(argv[0]),
            let options = VisionBarcodeDetectorOptions(argv[1]),
            let eventId = String(argv[2])
            else {
                return ArgCountError(message: "detect").getError(#file, #line, #column)
        }
        
        let barcodeDetector = vision.barcodeDetector(options: options)
        barcodeDetector.detect(in: image) { (features, error) in
            if let err = error as NSError? {
                self.sendEvent(name: BarcodeEvent.DETECTED,
                               value: BarcodeEvent(eventId: eventId,
                                                   error: ["text": err.localizedDescription,
                                                           "id": err.code]).toJSONString())
            } else {
                if let features = features, !features.isEmpty {
                    self.results[eventId] = features
                    self.sendEvent(name: BarcodeEvent.DETECTED,
                                   value: BarcodeEvent(eventId: eventId).toJSONString())
                }
            }
        }
        return nil
    }
    
    func getResults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return ArgCountError(message: "getResult").getError(#file, #line, #column)
        }
        do {
            if let result = results[eventId] {
                let freArray = try FREArray(className: "Vector.<com.tuarua.arane.Node>", args: result.count)
                var cnt: UInt = 0
                for barcode in result {
                    trace(barcode.debugDescription)
                    if let freBarcode = barcode?.toFREObject() {
                        try freArray.set(index: cnt, value: freBarcode)
                        cnt += 1
                    } 
                }
                return freArray.rawValue
            }
        } catch {}
        
        return nil
    }
    
}
