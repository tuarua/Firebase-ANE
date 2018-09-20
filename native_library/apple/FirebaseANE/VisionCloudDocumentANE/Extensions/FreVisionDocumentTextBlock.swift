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

public extension VisionDocumentTextBlock {
    func toFREObject() -> FREObject? {
        guard let fre = try? FREObject(className: "com.tuarua.firebase.vision.DocumentTextBlock"),
            var ret = fre
            else { return nil }
        ret["frame"] = self.frame.toFREObject()
        ret["text"] = self.text.toFREObject()
        ret["type"] = self.type.rawValue.toFREObject()
        ret["paragraphs"] = self.paragraphs.toFREObject()
        ret["confidence"] = self.confidence.toFREObject()
        ret["recognizedLanguages"] = self.recognizedLanguages.toFREObject()
        ret["recognizedBreak"] = self.recognizedBreak?.toFREObject()
        return ret
    }
}

public extension Array where Element == VisionDocumentTextBlock {
    func toFREObject() -> FREObject? {
        guard let ret = try? FREArray(className: "com.tuarua.firebase.vision.DocumentTextBlock",
                                      length: self.count, fixed: true) else { return nil }
        var cnt: UInt = 0
        for element in self {
            ret[cnt] = element.toFREObject()
            cnt+=1
        }
        return ret.rawValue
    }
}
