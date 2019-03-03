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

public extension VisionFaceDetectorOptions {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let classificationMode = VisionFaceDetectorClassificationMode(rawValue: UInt(rv["classificationMode"])
                ?? 1),
            let performanceMode = VisionFaceDetectorPerformanceMode(rawValue: UInt(rv["performanceMode"]) ?? 1),
            let landmarkMode = VisionFaceDetectorLandmarkMode(rawValue: UInt(rv["landmarkMode"]) ?? 1),
            let contourMode = VisionFaceDetectorContourMode(rawValue: UInt(rv["contourMode"]) ?? 1),
            let isTrackingEnabled = Bool(rv["isTrackingEnabled"]),
            let minFaceSize = CGFloat(rv["minFaceSize"])
            else { return nil }
        self.init()
        self.performanceMode = performanceMode
        self.classificationMode = classificationMode
        self.landmarkMode = landmarkMode
        self.contourMode = contourMode
        self.isTrackingEnabled = isTrackingEnabled
        self.minFaceSize = minFaceSize
    }
}
