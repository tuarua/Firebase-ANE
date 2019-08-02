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
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.ml.vision.common.LatitudeLongitude")
            else { return nil }
        ret.latitude = latitude ?? 0.0
        ret.longitude = longitude ?? 0.0
        return ret.rawValue
    }
}

public extension Array where Element == VisionLatitudeLongitude {
    func toFREObject() -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.firebase.ml.vision.common.LatitudeLongitude")
            else { return nil }
        for element in self {
            ret.push(element.toFREObject())
        }
        return ret.rawValue
    }
}

public extension FreObjectSwift {
    public subscript(dynamicMember name: String) -> [VisionLatitudeLongitude]? {
        get { return nil }
        set { rawValue?[name] = newValue?.toFREObject() }
    }
}
