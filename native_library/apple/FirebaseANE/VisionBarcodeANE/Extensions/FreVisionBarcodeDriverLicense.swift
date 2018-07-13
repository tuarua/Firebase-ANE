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
        guard let freObject = try? FREObject(className: "com.tuarua.firebase.vision.BarcodeDriverLicense"),
            var ret = freObject
            else { return nil }
        ret["addressCity"] = self.addressCity?.toFREObject()
        ret["addressState"] = self.addressState?.toFREObject()
        ret["addressStreet"] = self.addressStreet?.toFREObject()
        ret["addressZip"] = self.addressZip?.toFREObject()
        ret["birthDate"] = self.birthDate?.toFREObject()
        ret["documentType"] = self.documentType?.toFREObject()
        ret["expiryDate"] = self.expiryDate?.toFREObject()
        ret["firstName"] = self.firstName?.toFREObject()
        ret["gender"] = self.gender?.toFREObject()
        ret["issuingCountry"] = self.issuingCountry?.toFREObject()
        ret["issuingDate"] = self.issuingDate?.toFREObject()
        ret["lastName"] = self.lastName?.toFREObject()
        ret["licenseNumber"] = self.licenseNumber?.toFREObject()
        ret["middleName"] = self.middleName?.toFREObject()
        return ret
    }
}
