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
import FirebaseMLVision

public extension VisionBarcodePhone {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.vision.BarcodePhone",
                                    args: self.number,
                                    self.type.rawValue)
            return ret
        } catch {
        }
        return nil
    }
}

public extension Array where Element == VisionBarcodePhone {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREArray(className: "com.tuarua.firebase.vision.BarcodePhone",
                                   length: self.count, fixed: true)
            var cnt: UInt = 0
            for phone in self {
                if let frePhone = phone.toFREObject() {
                    try ret.set(index: cnt, value: frePhone)
                    cnt += 1
                }
            }
            return ret.rawValue
        } catch {
        }
        return nil
    }
}