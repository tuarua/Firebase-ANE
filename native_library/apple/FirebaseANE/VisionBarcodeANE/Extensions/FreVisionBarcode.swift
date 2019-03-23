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

public extension VisionBarcode {
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.vision.Barcode") else { return nil }
        ret.frame = frame
        ret["rawValue"] = rawValue?.toFREObject()
        ret.displayValue = displayValue
        ret.format = format.rawValue
        ret.cornerPoints = cornerPoints
        ret.valueType = valueType.rawValue
        ret.email = email
        ret.phone = phone
        ret.sms = sms
        ret.url = url
        ret.wifi = wifi
        ret.geoPoint = geoPoint
        ret.contactInfo = contactInfo
        ret.driverLicense = driverLicense
        ret.calendarEvent = calendarEvent
        return ret.rawValue
    }
}

public extension Array where Element == VisionBarcode {
    func toFREObject() -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.firebase.vision.Barcode",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject()
            index+=1
        }
        return ret.rawValue
    }
}
