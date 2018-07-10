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
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.vision.Barcode")
            try ret?.setProp(name: "frame", value: self.frame.toFREObject())
            try ret?.setProp(name: "rawValue", value: self.rawValue)
            try ret?.setProp(name: "displayValue", value: self.displayValue)
            try ret?.setProp(name: "format", value: self.format.rawValue)
            let freCornerPoints = try FREArray(className: "Vector.<flash.geom.Point>",
                                               args: self.cornerPoints?.count ?? 0)
            var cnt: UInt = 0
            for cornerPoint in self.cornerPoints ?? [] {
                if let freCornerPoint = cornerPoint.cgPointValue.toFREObject() {
                    try freCornerPoints.set(index: cnt, value: freCornerPoint)
                    cnt += 1
                }
            }
            try ret?.setProp(name: "cornerPoints", value: freCornerPoints)
            try ret?.setProp(name: "valueType", value: self.valueType.rawValue)
            try ret?.setProp(name: "email", value: self.email?.toFREObject())
            try ret?.setProp(name: "phone", value: self.phone?.toFREObject())
            try ret?.setProp(name: "sms", value: self.sms?.toFREObject())
            try ret?.setProp(name: "url", value: self.url?.toFREObject())
            try ret?.setProp(name: "wifi", value: self.wifi?.toFREObject())
            try ret?.setProp(name: "geoPoint", value: self.geoPoint?.toFREObject())
            try ret?.setProp(name: "contactInfo", value: self.contactInfo?.toFREObject())
            try ret?.setProp(name: "driverLicense", value: self.driverLicense?.toFREObject())
            try ret?.setProp(name: "calendarEvent", value: self.calendarEvent?.toFREObject())
            return ret
        } catch {
        }
        return nil
    }
}
