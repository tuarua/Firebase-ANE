/*
 * Copyright 2018 Tua Rua Ltd.
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
package com.tuarua.firebase.vision {
/**
 * Options for an image label detector.
 */
public class CloudLabelDetectorOptions {
    private var _confidenceThreshold:Number = 0.5;
    private var _enforceCertFingerprintMatch:Boolean;
    /**
     * API key to use for Cloud Vision API.  If <code>null</code>, the default API key from FirebaseApp will be
     * used.
     */
    public var apiKeyOverride:String;
    /**
     * Creates a new instance with the given detector options.
     *
     * @param confidenceThreshold The confidence threshold for labels returned by the label detector.
     *     Features returned by the label detector will have a confidence higher or equal to the given
     *     threshold. Values must be in range [0, 1]. If an invalid value is provided, the default
     *     threshold of 0.5 is used.
     * @param enforceCertFingerprintMatch Only allow registered application instances with matching certificate
     * fingerprint to use Cloud Vision API.
     * <p>Do not set this for debug build if you use simulators to test.</p>
     * Applies to Android only.
     * @return Label detector options.
     */
    public function CloudLabelDetectorOptions(confidenceThreshold:Number = 0.5, enforceCertFingerprintMatch:Boolean = false) {
        this._confidenceThreshold = confidenceThreshold;
        _enforceCertFingerprintMatch = enforceCertFingerprintMatch;
    }
    /**
     * The confidence threshold for labels returned by the label detector. Features returned by the
     * label detector will have a confidence higher or equal to the confidence threshold. Default value
     * is 0.5.
     */
    public function get confidenceThreshold():Number {
        return _confidenceThreshold;
    }

    /**
     * Only allow registered application instances with matching certificate
     * fingerprint to use Cloud Vision API.
     * <p>Do not set this for debug build if you use simulators to test.</p>
     * <p>Applies to Android only.</p>
     */

    public function get enforceCertFingerprintMatch():Boolean {
        return _enforceCertFingerprintMatch;
    }
}
}
