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
        guard let freObject = try? FREObject(className: "com.tuarua.firebase.vision.Barcode"),
            var ret = freObject else { return nil }
        guard let freCornerPoints = try? FREArray(className: "flash.geom.Point",
                                                 length: self.cornerPoints?.count ?? 0, fixed: true) else { return nil }
        ret["frame"] = self.frame.toFREObject()
        ret["rawValue"] = self.rawValue?.toFREObject()
        ret["displayValue"] = self.displayValue?.toFREObject()
        ret["format"] = self.format.rawValue.toFREObject()
        var cnt: UInt = 0
        for cornerPoint in self.cornerPoints ?? [] {
            if let freCornerPoint = cornerPoint.cgPointValue.toFREObject() {
                freCornerPoints[cnt] = freCornerPoint
                cnt += 1
            }
        }
        ret["cornerPoints"] = freCornerPoints.rawValue
        
        ret["valueType"] = self.valueType.rawValue.toFREObject()
        ret["email"] = self.email?.toFREObject()
        ret["phone"] = self.phone?.toFREObject()
        ret["sms"] = self.sms?.toFREObject()
        ret["url"] = self.url?.toFREObject()
        ret["wifi"] = self.wifi?.toFREObject()
        ret["geoPoint"] = self.geoPoint?.toFREObject()
        ret["contactInfo"] = self.contactInfo?.toFREObject()
        ret["driverLicense"] = self.driverLicense?.toFREObject()
        ret["calendarEvent"] = self.calendarEvent?.toFREObject()
        return ret
    }
}
