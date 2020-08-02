/*
 * Copyright 2020 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.mlkit.vision.face {
public class FaceDetection {
    private static var _faceDetector:FaceDetector;

    public static function getClient(options:FaceDetectorOptions = null):FaceDetector {
        if (_faceDetector != null) {
            _faceDetector.reinit(options);
        } else {
            _faceDetector = new FaceDetector(options);
        }
        return _faceDetector;
    }

    /** Disposes the ANE and any Detector ANEs. */
    public static function dispose():void {
        if (FaceDetector.context) {
            FaceDetector.dispose();
        }
        _faceDetector = null;
    }
}
}
