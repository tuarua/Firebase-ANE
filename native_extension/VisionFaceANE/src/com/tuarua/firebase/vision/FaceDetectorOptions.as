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
package com.tuarua.firebase.vision {
/**
 * Options for specifying a face detector.
 */
public class FaceDetectorOptions {
    /**
     * Whether to run additional classifiers for characterizing attributes such as smiling. Defaults to
     * VisionFaceDetectorClassificationNone.
     */
    public var classificationType:uint = FaceDetectorClassification.none;
    /**
     * Preference for accuracy vs. speed trade-offs in face detection.  Defaults to
     * VisionFaceDetectorModeFast.
     */
    public var modeType:uint = FaceDetectorMode.fast;
    /**
     * <p>Whether to detect no landmarks or all landmarks in face detection. Processing time increases as<br>
     * the number of landmarks to search for increases, so detecting all landmarks will increase the<br>
     * overall detection time. Defaults to VisionFaceDetectorLandmarkNone.</p>
     */
    public var landmarkType:uint = FaceDetectorLandmark.none;
    /**
     * Whether the face tracking feature is enabled in face detection. Defaults to NO.
     */
    public var isTrackingEnabled:Boolean = false;
    /**
     * <p>The smallest desired face size. The size is expressed as a proportion of the width of the head to<br>
     * the image width. For example, if a value of 0.1 is specified, then the smallest face to search<br>
     * for is roughly 10% of the width of the image being searched. Defaults to 0.1.</p>
     */
    public var minFaceSize:Number = 0.1;
    /** @private */
    public function FaceDetectorOptions() {
    }
}
}