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
        guard let freFace = try? FREObject(className: "com.tuarua.firebase.vision.Face")
            else { return nil }
        guard let freLandMarks = try? FREArray(className: "Vector.<com.tuarua.firebase.vision.FaceLandmark>",
                                         args: 0) else { return nil }
        var ret = freFace
        ret?["frame"] = self.frame.toFREObject()
        ret?["hasTrackingID"] = self.hasTrackingID.toFREObject()
        ret?["trackingID"] = self.trackingID.toFREObject()
        ret?["hasHeadEulerAngleY"] = self.hasHeadEulerAngleY.toFREObject()
        ret?["headEulerAngleY"] = self.headEulerAngleY.toFREObject()
        ret?["hasHeadEulerAngleZ"] = self.hasHeadEulerAngleZ.toFREObject()
        ret?["headEulerAngleZ"] = self.headEulerAngleZ.toFREObject()
        ret?["hasSmilingProbability"] = self.hasSmilingProbability.toFREObject()
        ret?["smilingProbability"] = self.smilingProbability.toFREObject()
        ret?["hasLeftEyeOpenProbability"] = self.hasLeftEyeOpenProbability.toFREObject()
        ret?["leftEyeOpenProbability"] = self.leftEyeOpenProbability.toFREObject()
        ret?["hasRightEyeOpenProbability"] = self.hasRightEyeOpenProbability.toFREObject()
        ret?["rightEyeOpenProbability"] = self.rightEyeOpenProbability.toFREObject()

        // landmarks
        
        var cnt: UInt = 0
        if let leftEye = self.landmark(ofType: .leftEye)?.toFREObject() {
            freLandMarks[cnt] = leftEye
            cnt+=1
        }
        if let rightEye = self.landmark(ofType: .rightEye)?.toFREObject() {
            freLandMarks[cnt] = rightEye
            cnt+=1
        }
        if let mouthBottom = self.landmark(ofType: .mouthBottom)?.toFREObject() {
            freLandMarks[cnt] = mouthBottom
            cnt+=1
        }
        if let mouthRight = self.landmark(ofType: .mouthRight)?.toFREObject() {
            freLandMarks[cnt] = mouthRight
            cnt+=1
        }
        if let mouthLeft = self.landmark(ofType: .mouthLeft)?.toFREObject() {
            freLandMarks[cnt] = mouthLeft
            cnt+=1
        }
        if let leftEar = self.landmark(ofType: .leftEar)?.toFREObject() {
            freLandMarks[cnt] = leftEar
            cnt+=1
        }
        if let rightEar = self.landmark(ofType: .rightEar)?.toFREObject() {
            freLandMarks[cnt] = rightEar
            cnt+=1
        }
        if let leftCheek = self.landmark(ofType: .leftCheek)?.toFREObject() {
            freLandMarks[cnt] = leftCheek
            cnt+=1
        }
        if let rightCheek = self.landmark(ofType: .rightCheek)?.toFREObject() {
            freLandMarks[cnt] = rightCheek
            cnt+=1
        }
        if let noseBase = self.landmark(ofType: .noseBase)?.toFREObject() {
            freLandMarks[cnt] = noseBase
            cnt+=1
        }
        
        ret?["landmarks"] = freLandMarks.rawValue
        return ret
    }
}
