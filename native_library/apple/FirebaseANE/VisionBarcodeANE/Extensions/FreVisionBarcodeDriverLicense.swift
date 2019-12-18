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

public extension VisionBarcodeDriverLicense {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.ml.vision.barcode.BarcodeDriverLicense")
            else { return nil }
        ret.addressCity = addressCity
        ret.addressState = addressState
        ret.addressStreet = addressStreet
        ret.addressZip = addressZip
        ret.birthDate = birthDate
        ret.documentType = documentType
        ret.expiryDate = expiryDate
        ret.firstName = firstName
        ret.gender = gender
        ret.issuingCountry = issuingCountry
        ret.issuingDate = issuingDate
        ret.lastName = lastName
        ret.licenseNumber = licenseNumber
        ret.middleName = middleName
        return ret.rawValue
    }
}

public extension FreObjectSwift {
    subscript(dynamicMember name: String) -> VisionBarcodeDriverLicense? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
