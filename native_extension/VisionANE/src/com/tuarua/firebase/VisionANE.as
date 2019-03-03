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
import com.tuarua.firebase.vision.CloudDocumentRecognizerOptions;
import com.tuarua.firebase.vision.CloudTextRecognizerOptions;
import com.tuarua.firebase.vision.FaceDetectorOptions;
import com.tuarua.firebase.vision.CloudLabelDetectorOptions;
import com.tuarua.firebase.vision.LabelDetectorOptions;
import com.tuarua.firebase.vision.display.CameraOverlay;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class VisionANE extends EventDispatcher {
    private var _barcodeDetector:BarcodeDetector;
    private var _faceDetector:FaceDetector;
    private var _textRecognizer:TextRecognizer;
    private var _cloudTextRecognizer:CloudTextRecognizer;
    private var _labelDetector:LabelDetector;
    private var _cloudLabelDetector:CloudLabelDetector;
    private var _cloudLandmarkDetector:CloudLandmarkDetector;
    private var _cloudDocumentTextRecognizer:CloudDocumentRecognizer;
    private static var _vision:VisionANE;
    private var _cameraOverlay:CameraOverlay = new CameraOverlay();

    /** @private */
    public function VisionANE() {
        if (VisionANEContext.context) {
            var ret:* = VisionANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _vision = this;
    }

    /**
     * Gets a barcode detector with the given options.
     *
     * @param options Options containing barcode detector configuration.
     * @return A barcode detector configured with the given options.
     */
    public function barcodeDetector(options:BarcodeDetectorOptions = null):BarcodeDetector {
        if (_barcodeDetector != null) {
            _barcodeDetector.reinit(options);
        } else {
            _barcodeDetector = new BarcodeDetector(options);
        }
        return _barcodeDetector;
    }

    /**
     * Gets a face detector with the given options.
     *
     * @param options Options for configuring the face detector.
     * @return A face detector configured with the given options.
     */
    public function faceDetector(options:FaceDetectorOptions = null):FaceDetector {
        if (_faceDetector != null) {
            _faceDetector.reinit(options);
        } else {
            _faceDetector = new FaceDetector(options);
        }
        return _faceDetector;
    }

    /**
     * Gets an on-device text recognizer.
     *
     * @return A text recognizer.
     */
    public function onDeviceTextRecognizer():TextRecognizer {
        if (_textRecognizer == null) {
            _textRecognizer = new TextRecognizer();
        }
        return _textRecognizer
    }

    /**
     * Gets a cloud text recognizer configured with the given options.
     *
     * @param options Options for configuring the cloud text recognizer.
     * @return A text recognizer configured with the given options.
     */
    public function cloudTextRecognizer(options:CloudTextRecognizerOptions = null):CloudTextRecognizer {
        if (_cloudTextRecognizer != null) {
            _cloudTextRecognizer.reinit(options);
        } else {
            _cloudTextRecognizer = new CloudTextRecognizer(options);
        }
        return _cloudTextRecognizer
    }

    /**
     * Gets a cloud document text recognizer configured with the given options.
     *
     * @param options Options for configuring the cloud document text recognizer.
     * @return A document text recognizer configured with the given options.
     */
    public function cloudDocumentTextRecognizer(options:CloudDocumentRecognizerOptions = null):CloudDocumentRecognizer {
        if (_cloudDocumentTextRecognizer != null) {
            _cloudDocumentTextRecognizer.reinit(options);
        } else {
            _cloudDocumentTextRecognizer = new CloudDocumentRecognizer(options);
        }
        return _cloudDocumentTextRecognizer
    }

    /**
     * Gets a label detector with the given options.
     *
     * @param options Options for configuring the label detector.
     * @return A label detector configured with the given options.
     */
    public function labelDetector(options:LabelDetectorOptions = null):LabelDetector {
        if (_labelDetector != null) {
            _labelDetector.reinit(options);
        } else {
            _labelDetector = new LabelDetector(options);
        }
        return _labelDetector;
    }

    /**
     * Gets an instance of cloud label detector with the given options.
     *
     * @param options Options for configuring the cloud label detector.
     * @return A cloud label detector configured with the given options.
     */
    public function cloudLabelDetector(options:CloudLabelDetectorOptions = null):CloudLabelDetector {
        if (_cloudLabelDetector != null) {
            _cloudLabelDetector.reinit(options);
        } else {
            _cloudLabelDetector = new CloudLabelDetector(options);
        }
        return _cloudLabelDetector
    }

    /**
     * Gets an instance of cloud landmark detector with the given options.
     *
     * @param options Options for configuring the cloud landmark detector.
     * @return A cloud landmark detector configured with the given options.
     */
    public function cloudLandmarkDetector(options:CloudDetectorOptions = null):CloudLandmarkDetector {
        if (_cloudLandmarkDetector != null) {
            _cloudLandmarkDetector.reinit(options);
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

    /** Requests permissions for this ANE. */
    public function requestPermissions():void {
        if (VisionANEContext.context) {
            VisionANEContext.context.call("requestPermissions");
        }
    }

    /** Whether the camera is supported on users version of Android (21 or >). */
    public function get isCameraSupported():Boolean {
        if (VisionANEContext.context) {
            return VisionANEContext.context.call("isCameraSupported") as Boolean;
        }
        return false;
    }

    public function get cameraOverlay():CameraOverlay {
        return _cameraOverlay;
    }

    /** Disposes the ANE and any Detector ANEs. */
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
        if (TextRecognizer.context) {
            TextRecognizer.dispose();
        }
        if (CloudTextRecognizer.context) {
            CloudTextRecognizer.dispose();
        }
        if (CloudDocumentRecognizer.context) {
            CloudDocumentRecognizer.dispose();
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
