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

public extension VisionFace {
    func toFREObject() -> FREObject? {
        guard let freFace = try? FREObject(className: "com.tuarua.firebase.vision.Face"),
        var ret = freFace
            else { return nil }
        
        guard let freLandMarks = try? FREArray(className: "com.tuarua.firebase.vision.FaceLandmark",
                                               length: 0) else { return nil }
        
        ret["frame"] = self.frame.toFREObject()
        ret["hasTrackingId"] = self.hasTrackingID.toFREObject()
        ret["trackingId"] = self.trackingID.toFREObject()
        ret["hasHeadEulerAngleY"] = self.hasHeadEulerAngleY.toFREObject()
        ret["headEulerAngleY"] = self.headEulerAngleY.toFREObject()
        ret["hasHeadEulerAngleZ"] = self.hasHeadEulerAngleZ.toFREObject()
        ret["headEulerAngleZ"] = self.headEulerAngleZ.toFREObject()
        ret["hasSmilingProbability"] = self.hasSmilingProbability.toFREObject()
        ret["smilingProbability"] = self.smilingProbability.toFREObject()
        ret["hasLeftEyeOpenProbability"] = self.hasLeftEyeOpenProbability.toFREObject()
        ret["leftEyeOpenProbability"] = self.leftEyeOpenProbability.toFREObject()
        ret["hasRightEyeOpenProbability"] = self.hasRightEyeOpenProbability.toFREObject()
        ret["rightEyeOpenProbability"] = self.rightEyeOpenProbability.toFREObject()

        let types: [FaceLandmarkType] = [.leftEye, .rightEye,
                                         .mouthBottom, .mouthRight, .mouthLeft,
                                         .leftEar, .rightEar,
                                         .leftCheek, .rightCheek,
                                         .noseBase]
        
        var cnt: UInt = 0
        for type in types {
            if let lm = self.landmark(ofType: type)?.toFREObject() {
                freLandMarks[cnt] = lm
                cnt+=1
            }
        }
        
        ret["landmarks"] = freLandMarks.rawValue
        return ret
    }
}
