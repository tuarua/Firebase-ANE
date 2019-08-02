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

public extension VisionBarcodePersonName {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.ml.vision.barcode.BarcodePersonName")
            else { return nil }
        ret.formattedName = formattedName
        ret.first = first
        ret.last = last
        ret.middle = middle
        ret.prefix = prefix
        ret.pronunciation = pronounciation
        ret.suffix = suffix
        return ret.rawValue
    }
}

public extension FreObjectSwift {
    public subscript(dynamicMember name: String) -> VisionBarcodePersonName? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
