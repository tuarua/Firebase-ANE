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

public extension VisionBarcodeEmail {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.vision.BarcodeEmail")
            try ret?.setProp(name: "address", value: self.address)
            try ret?.setProp(name: "body", value: self.body)
            try ret?.setProp(name: "subject", value: self.subject)
            try ret?.setProp(name: "type", value: self.type.rawValue)
            return ret
        } catch {
        }
        return nil
    }
}

public extension Array where Element == VisionBarcodeEmail {
    func toFREObject() -> FREArray? {
        do {
            let ret = try FREArray(className: "Vector.<com.tuarua.firebase.vision.BarcodeEmail>",
                                   args: self.count)
            var cnt: UInt = 0
            for email in self {
                if let freEmail = email.toFREObject() {
                    try ret.set(index: cnt, value: freEmail)
                    cnt += 1
                }
            }
            return ret
        } catch {
        }
        return nil
    }
}
