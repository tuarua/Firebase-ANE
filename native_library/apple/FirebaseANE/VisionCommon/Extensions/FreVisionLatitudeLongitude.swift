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

public extension VisionLatitudeLongitude {
    func toFREObject() -> FREObject? {
        guard let fre = try? FREObject(className: "com.tuarua.firebase.vision.LatitudeLongitude"),
            var ret = fre
            else { return nil }
        let lat = self.latitude ?? 0.0
        let lng = self.longitude ?? 0.0
        ret["latitude"] = lat.toFREObject()
        ret["longitude"] = lng.toFREObject()
        return ret
    }
}

public extension Array where Element == VisionLatitudeLongitude {
    func toFREObject() -> FREObject? {
        guard let ret = try? FREArray(className: "com.tuarua.firebase.vision.LatitudeLongitude",
                                      length: self.count, fixed: true) else { return nil }
        var cnt: UInt = 0
        for element in self {
            ret[cnt] = element.toFREObject()
            cnt+=1
        }
        return ret.rawValue
    }
}
