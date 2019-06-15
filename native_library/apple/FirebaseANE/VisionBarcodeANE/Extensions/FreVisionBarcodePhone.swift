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
        return FREObject(className: "com.tuarua.firebase.ml.vision.barcode.BarcodePhone",
                                args: self.number,
                                self.type.rawValue)
    }
}

public extension Array where Element == VisionBarcodePhone {
    func toFREObject() -> FREObject? {
            guard let ret = FREArray(className: "com.tuarua.firebase.ml.vision.barcode.BarcodePhone",
                                     length: self.count, fixed: true) else { return nil }
            var cnt: UInt = 0
            for phone in self {
                if let frePhone = phone.toFREObject() {
                    ret[cnt] = frePhone
                    cnt += 1
                }
            }
            return ret.rawValue
    }
}

public extension FreObjectSwift {
    public subscript(dynamicMember name: String) -> VisionBarcodePhone? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}

public extension FreObjectSwift {
    public subscript(dynamicMember name: String) -> [VisionBarcodePhone]? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
