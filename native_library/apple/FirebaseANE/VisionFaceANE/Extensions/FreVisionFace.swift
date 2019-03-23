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
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.vision.Face"),
        let freLandMarks = FREArray(className: "com.tuarua.firebase.vision.FaceLandmark") else { return nil }
        
        ret.frame = frame
        ret.hasTrackingId = hasTrackingID
        ret.trackingId = trackingID
        ret.hasHeadEulerAngleY = hasHeadEulerAngleY
        ret.headEulerAngleY = headEulerAngleY
        ret.hasHeadEulerAngleZ = hasHeadEulerAngleZ
        ret.headEulerAngleZ = headEulerAngleZ
        ret.hasSmilingProbability = hasSmilingProbability
        ret.smilingProbability = smilingProbability
        ret.hasLeftEyeOpenProbability = hasLeftEyeOpenProbability
        ret.leftEyeOpenProbability = leftEyeOpenProbability
        ret.hasRightEyeOpenProbability = hasRightEyeOpenProbability
        ret.rightEyeOpenProbability = rightEyeOpenProbability

        let types: [FaceLandmarkType] = [.leftEye, .rightEye,
                                         .mouthBottom, .mouthRight, .mouthLeft,
                                         .leftEar, .rightEar,
                                         .leftCheek, .rightCheek,
                                         .noseBase]
        
        for type in types {
            freLandMarks.push(landmark(ofType: type)?.toFREObject())
        }
        
        ret.landmarks = freLandMarks
        return ret.rawValue
    }
}

public extension Array where Element == VisionFace {
    func toFREObject() -> FREObject? {
        guard let ret = FREArray(className: "com.tuarua.firebase.vision.Face",
                                 length: self.count, fixed: true) else { return nil }
        var index: UInt = 0
        for element in self {
            ret[index] = element.toFREObject()
            index+=1
        }
        return ret.rawValue
    }
}
