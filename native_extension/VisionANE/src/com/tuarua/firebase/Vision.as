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
import com.tuarua.firebase.ml.vision.barcode.BarcodeDetector;
import com.tuarua.firebase.ml.vision.barcode.BarcodeDetectorOptions;
import com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmarkDetector;
import com.tuarua.firebase.ml.vision.document.CloudDocumentTextRecognizer;
import com.tuarua.firebase.ml.vision.face.FaceDetector;
import com.tuarua.firebase.ml.vision.label.CloudImageLabeler;
import com.tuarua.firebase.ml.vision.label.OnDeviceImageLabeler;
import com.tuarua.firebase.ml.vision.cloud.CloudDetectorOptions;
import com.tuarua.firebase.ml.vision.document.CloudDocumentRecognizerOptions;
import com.tuarua.firebase.ml.vision.text.CloudTextRecognizer;
import com.tuarua.firebase.ml.vision.text.CloudTextRecognizerOptions;
import com.tuarua.firebase.ml.vision.face.FaceDetectorOptions;
import com.tuarua.firebase.ml.vision.label.CloudImageLabelerOptions;
import com.tuarua.firebase.ml.vision.label.OnDeviceImageLabelerOptions;
import com.tuarua.firebase.ml.vision.text.TextRecognizer;
import com.tuarua.firebase.vision.display.CameraOverlay;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class Vision extends EventDispatcher {
    private var _barcodeDetector:BarcodeDetector;
    private var _faceDetector:FaceDetector;
    private var _textRecognizer:TextRecognizer;
    private var _cloudTextRecognizer:CloudTextRecognizer;
    private var _labelDetector:OnDeviceImageLabeler;
    private var _cloudLabelDetector:CloudImageLabeler;
    private var _cloudLandmarkDetector:CloudLandmarkDetector;
    private var _cloudDocumentTextRecognizer:CloudDocumentTextRecognizer;
    private static var _vision:Vision;
    private var _cameraOverlay:CameraOverlay = new CameraOverlay();

    /** @private */
    public function Vision() {
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
    public function cloudDocumentTextRecognizer(options:CloudDocumentRecognizerOptions = null):CloudDocumentTextRecognizer {
        if (_cloudDocumentTextRecognizer != null) {
            _cloudDocumentTextRecognizer.reinit(options);
        } else {
            _cloudDocumentTextRecognizer = new CloudDocumentTextRecognizer(options);
        }
        return _cloudDocumentTextRecognizer
    }

    /**
     * Gets a label detector with the given options.
     *
     * @param options Options for configuring the label detector.
     * @return A label detector configured with the given options.
     */
    public function labelDetector(options:OnDeviceImageLabelerOptions = null):OnDeviceImageLabeler {
        if (_labelDetector != null) {
            _labelDetector.reinit(options);
        } else {
            _labelDetector = new OnDeviceImageLabeler(options);
        }
        return _labelDetector;
    }

    /**
     * Gets an instance of cloud label detector with the given options.
     *
     * @param options Options for configuring the cloud label detector.
     * @return A cloud label detector configured with the given options.
     */
    public function cloudLabelDetector(options:CloudImageLabelerOptions = null):CloudImageLabeler {
        if (_cloudLabelDetector != null) {
            _cloudLabelDetector.reinit(options);
        } else {
            _cloudLabelDetector = new CloudImageLabeler(options);
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
    public static function get vision():Vision {
        if (!_vision) {
            new Vision();
        }
        return _vision;
    }

    /** Requests permissions for this ANE. */
    public function requestPermissions():void {
        if (VisionANEContext.context) {
            var ret:* = VisionANEContext.context.call("requestPermissions");
            if (ret is ANEError) throw ret as ANEError;
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
        if (CloudDocumentTextRecognizer.context) {
            CloudDocumentTextRecognizer.dispose();
        }
        if (OnDeviceImageLabeler.context) {
            OnDeviceImageLabeler.dispose();
        }
        if (CloudImageLabeler.context) {
            CloudImageLabeler.dispose();
        }
        if (CloudLandmarkDetector.context) {
            CloudLandmarkDetector.dispose();
        }
    }

}
}
