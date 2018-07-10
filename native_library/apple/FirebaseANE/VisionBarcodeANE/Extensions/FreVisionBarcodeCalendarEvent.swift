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

public extension VisionBarcodeCalendarEvent {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.vision.BarcodeCalendarEvent")
            try ret?.setProp(name: "end", value: self.end?.toFREObject())
            try ret?.setProp(name: "eventDescription", value: self.eventDescription)
            try ret?.setProp(name: "location", value: self.location)
            try ret?.setProp(name: "organizer", value: self.organizer)
            try ret?.setProp(name: "start", value: self.start?.toFREObject())
            try ret?.setProp(name: "status", value: self.status)
            try ret?.setProp(name: "summary", value: self.summary)
            return ret
        } catch {
        }
        return nil
    }
}
