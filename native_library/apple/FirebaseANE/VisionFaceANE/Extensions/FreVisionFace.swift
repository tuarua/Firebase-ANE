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
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.vision.Face")
            try ret?.setProp(name: "frame", value: self.frame.toFREObject())
            try ret?.setProp(name: "hasTrackingID", value: self.hasTrackingID)
            try ret?.setProp(name: "trackingID", value: self.trackingID)
            try ret?.setProp(name: "hasHeadEulerAngleY", value: self.hasHeadEulerAngleY)
            try ret?.setProp(name: "headEulerAngleY", value: self.headEulerAngleY.toFREObject())
            try ret?.setProp(name: "hasHeadEulerAngleZ", value: self.hasHeadEulerAngleZ)
            try ret?.setProp(name: "headEulerAngleZ", value: self.headEulerAngleZ.toFREObject())
            try ret?.setProp(name: "hasSmilingProbability", value: self.hasSmilingProbability)
            try ret?.setProp(name: "smilingProbability", value: self.smilingProbability.toFREObject())
            try ret?.setProp(name: "hasLeftEyeOpenProbability", value: self.hasLeftEyeOpenProbability)
            try ret?.setProp(name: "leftEyeOpenProbability", value: self.leftEyeOpenProbability.toFREObject())
            try ret?.setProp(name: "hasRightEyeOpenProbability", value: self.hasRightEyeOpenProbability)
            try ret?.setProp(name: "rightEyeOpenProbability", value: self.rightEyeOpenProbability.toFREObject())
            
            // landmarks
            let freLandMarks = try FREArray(className: "Vector.<com.tuarua.firebase.vision.VisionFaceLandmark>",
                                   args: 0)
            
            var cnt: UInt = 0
            if let leftEye = self.landmark(ofType: .leftEye)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: leftEye)
                cnt+=1
            }
            if let rightEye = self.landmark(ofType: .rightEye)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: rightEye)
                cnt+=1
            }
            if let mouthBottom = self.landmark(ofType: .mouthBottom)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: mouthBottom)
                cnt+=1
            }
            if let mouthRight = self.landmark(ofType: .mouthRight)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: mouthRight)
                cnt+=1
            }
            if let mouthLeft = self.landmark(ofType: .mouthLeft)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: mouthLeft)
                cnt+=1
            }
            if let leftEar = self.landmark(ofType: .leftEar)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: leftEar)
                cnt+=1
            }
            if let rightEar = self.landmark(ofType: .rightEar)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: rightEar)
                cnt+=1
            }
            if let leftCheek = self.landmark(ofType: .leftCheek)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: leftCheek)
                cnt+=1
            }
            if let rightCheek = self.landmark(ofType: .rightCheek)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: rightCheek)
                cnt+=1
            }
            if let noseBase = self.landmark(ofType: .noseBase)?.toFREObject() {
                try freLandMarks.set(index: cnt, value: noseBase)
                cnt+=1
            }
            try ret?.setProp(name: "landmarks", value: freLandMarks.rawValue)
            
            return ret
        } catch {
        }
        return nil
    }
}
