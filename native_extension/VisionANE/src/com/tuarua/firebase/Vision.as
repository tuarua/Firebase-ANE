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
import com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmarkDetector;
import com.tuarua.firebase.ml.vision.document.CloudDocumentTextRecognizer;
import com.tuarua.firebase.ml.vision.label.CloudImageLabeler;
import com.tuarua.firebase.ml.vision.cloud.CloudDetectorOptions;
import com.tuarua.firebase.ml.vision.document.CloudDocumentRecognizerOptions;
import com.tuarua.firebase.ml.vision.text.CloudTextRecognizer;
import com.tuarua.firebase.ml.vision.text.CloudTextRecognizerOptions;
import com.tuarua.firebase.ml.vision.label.CloudImageLabelerOptions;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class Vision extends EventDispatcher {
    private var _cloudTextRecognizer:CloudTextRecognizer;
    private var _cloudLabelDetector:CloudImageLabeler;
    private var _cloudLandmarkDetector:CloudLandmarkDetector;
    private var _cloudDocumentTextRecognizer:CloudDocumentTextRecognizer;
    private static var _vision:Vision;

    /** @private */
    public function Vision() {
        if (VisionANEContext.context) {
            var ret:* = VisionANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _vision = this;
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

    /** Disposes the ANE and any Detector ANEs. */
    public static function dispose():void {
        if (VisionANEContext.context) {
            VisionANEContext.dispose();
        }
        if (CloudTextRecognizer.context) {
            CloudTextRecognizer.dispose();
        }
        if (CloudDocumentTextRecognizer.context) {
            CloudDocumentTextRecognizer.dispose();
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
