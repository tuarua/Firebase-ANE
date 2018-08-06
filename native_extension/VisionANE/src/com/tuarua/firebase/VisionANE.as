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

package com.tuarua.firebase {
import com.tuarua.firebase.vision.BarcodeDetectorOptions;
import com.tuarua.firebase.vision.CloudDetectorOptions;
import com.tuarua.firebase.vision.FaceDetectorOptions;
import com.tuarua.firebase.vision.LabelDetectorOptions;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class VisionANE extends EventDispatcher {
    private var _barcodeDetector:BarcodeDetector;
    private var _faceDetector:FaceDetector;
    private var _textDetector:TextDetector;
    private var _cloudTextDetector:CloudTextDetector;
    private var _labelDetector:LabelDetector;
    private var _cloudLabelDetector:CloudLabelDetector;
    private var _cloudLandmarkDetector:CloudLandmarkDetector;
    private static var _vision:VisionANE;

    public function VisionANE() {
        if (VisionANEContext.context) {
            var theRet:* = VisionANEContext.context.call("init");
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _vision = this;
    }

    public function barcodeDetector(options:BarcodeDetectorOptions = null):BarcodeDetector {
        if (_barcodeDetector != null) {
            _barcodeDetector.options = options;
        } else {
            _barcodeDetector = new BarcodeDetector(options);
        }
        return _barcodeDetector;
    }

    public function faceDetector(options:FaceDetectorOptions = null):FaceDetector {
        if (_faceDetector != null) {
            _faceDetector.options = options;
        } else {
            _faceDetector = new FaceDetector(options);
        }
        return _faceDetector;
    }

    public function textDetector():TextDetector {
        if (_textDetector == null) {
            _textDetector = new TextDetector();
        }
        return _textDetector
    }

    public function cloudTextDetector(options:CloudDetectorOptions = null):CloudTextDetector {
        if (_cloudTextDetector != null) {
            _cloudTextDetector.options = options;
        } else {
            _cloudTextDetector = new CloudTextDetector(options);
        }
        return _cloudTextDetector
    }

    public function labelDetector(options:LabelDetectorOptions = null):LabelDetector {
        if (_labelDetector != null) {
            _labelDetector.options = options;
        } else {
            _labelDetector = new LabelDetector(options);
        }
        return _labelDetector;
    }

    public function cloudLabelDetector(options:CloudDetectorOptions = null):CloudLabelDetector {
        if (_cloudLabelDetector != null) {
            _cloudLabelDetector.options = options;
        } else {
            _cloudLabelDetector = new CloudLabelDetector(options);
        }
        return _cloudLabelDetector
    }

    public function cloudLandmarkDetector(options:CloudDetectorOptions = null):CloudLandmarkDetector {
        if (_cloudLandmarkDetector != null) {
            _cloudLandmarkDetector.options = options;
        } else {
            _cloudLandmarkDetector = new CloudLandmarkDetector(options);
        }
        return _cloudLandmarkDetector
    }

    /** The Vision ANE instance. */
    public static function get vision():VisionANE {
        if (!_vision) {
            new VisionANE();
        }
        return _vision;
    }

    /** Requests permissions for this ANE */
    public function requestPermissions():void {
        if (VisionANEContext.context) {
            VisionANEContext.context.call("requestPermissions");
        }
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (VisionANEContext.context) {
            VisionANEContext.dispose();
        }
        if (BarcodeDetector.context) {
            BarcodeDetector.dispose();
        }
        if (FaceDetector.context) {
            FaceDetector.dispose();
        }
        if (TextDetector.context) {
            TextDetector.dispose();
        }
        if (CloudTextDetector.context) {
            CloudTextDetector.dispose();
        }
        if (LabelDetector.context) {
            LabelDetector.dispose();
        }
        if (CloudLabelDetector.context) {
            CloudLabelDetector.dispose();
        }
        if (CloudLandmarkDetector.context) {
            CloudLandmarkDetector.dispose();
        }

    }


}
}
