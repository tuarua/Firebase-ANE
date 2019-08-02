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

public extension VisionDocumentTextWord {
    func toFREObject(resultId: String, blockIndex: Int, paragraphIndex: Int, index: UInt) -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.ml.vision.document.DocumentTextWord",
                                       args: resultId, blockIndex, paragraphIndex, index) else { return nil }
        
        ret.frame = frame
        ret.text = text
        ret.confidence = confidence
        ret.recognizedBreak = recognizedBreak?.toFREObject()
        ret.recognizedLanguages = recognizedLanguages.toFREObject()
        return ret.rawValue
    }
}

public extension Array where Element == VisionDocumentTextWord {
    func toFREObject(resultId: String, blockIndex: Int, paragraphIndex: Int) -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.firebase.ml.vision.document.DocumentTextWord")
            else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject(resultId: resultId, blockIndex: blockIndex,
                                             paragraphIndex: paragraphIndex, index: index)
            index+=1
        }
        return ret.rawValue
    }
}
