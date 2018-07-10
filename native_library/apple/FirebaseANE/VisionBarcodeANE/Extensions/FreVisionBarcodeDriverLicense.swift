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
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.vision.BarcodeDriverLicense")
            try ret?.setProp(name: "addressCity", value: self.addressCity)
            try ret?.setProp(name: "addressState", value: self.addressState)
            try ret?.setProp(name: "addressStreet", value: self.addressStreet)
            try ret?.setProp(name: "addressZip", value: self.addressZip)
            try ret?.setProp(name: "birthDate", value: self.birthDate)
            try ret?.setProp(name: "documentType", value: self.documentType)
            try ret?.setProp(name: "expiryDate", value: self.expiryDate)
            try ret?.setProp(name: "firstName", value: self.firstName)
            try ret?.setProp(name: "gender", value: self.gender)
            try ret?.setProp(name: "issuingCountry", value: self.issuingCountry)
            try ret?.setProp(name: "issuingDate", value: self.issuingDate)
            try ret?.setProp(name: "lastName", value: self.lastName)
            try ret?.setProp(name: "licenseNumber", value: self.licenseNumber)
            try ret?.setProp(name: "middleName", value: self.middleName)
            return ret
        } catch {
        }
        return nil
    }
}
