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
        guard let freObject = try? FREObject(className: "com.tuarua.firebase.vision.BarcodePersonName"),
            var ret = freObject
            else { return nil }
        ret["formattedName"] = self.formattedName?.toFREObject()
        ret["first"] = self.first?.toFREObject()
        ret["last"] = self.last?.toFREObject()
        ret["middle"] = self.middle?.toFREObject()
        ret["prefix"] = self.prefix?.toFREObject()
        ret["pronounciation"] = self.pronounciation?.toFREObject()
        ret["suffix"] = self.suffix?.toFREObject()
        return ret
    }
}
