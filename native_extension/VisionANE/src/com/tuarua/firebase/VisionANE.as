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
import com.tuarua.firebase.vision.FaceDetectorOptions;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class VisionANE extends EventDispatcher {
    private var _barcodeDetector:BarcodeDetector;
    private var _faceDetector:FaceDetector;
    private static var _vision:VisionANE;

    public function VisionANE() {
        if (VisionANEContext.context) {
            var theRet:* = VisionANEContext.context.call("init");
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _vision = this;
    }

    public function barcodeDetector(options:BarcodeDetectorOptions = null):BarcodeDetector {
        if (_barcodeDetector) {
            _barcodeDetector.options = options;
        } else {
            _barcodeDetector = new BarcodeDetector(options);
        }
        return _barcodeDetector;
    }

    public function faceDetector(options:FaceDetectorOptions = null):FaceDetector {
        if (_faceDetector) {
            _faceDetector.options = options;
        } else {
            _faceDetector = new FaceDetector(options);
        }
        return _faceDetector;
    }

    /** The Vision ANE instance. */
    public static function get vision():VisionANE {
        if (!_vision) {
            new VisionANE();
        }
        return _vision;
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
    }

}
}
