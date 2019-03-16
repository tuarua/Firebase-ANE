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
[RemoteClass(alias="com.tuarua.firebase.vision.LabelDetectorOptions")]
/**
 * Options for an image label detector.
 */
public class LabelDetectorOptions {
    private var _confidenceThreshold:Number = 0.5;
    /**
     * Creates a new instance with the given detector options.
     *
     * @param confidenceThreshold The confidence threshold for labels returned by the label detector.
     *     Features returned by the label detector will have a confidence higher or equal to the given
     *     threshold. Values must be in range [0, 1]. If an invalid value is provided, the default
     *     threshold of 0.5 is used.
     * @return com.tuarua.firebase.vision.ImageLabel detector options.
     */
    public function LabelDetectorOptions(confidenceThreshold:Number = 0.5) {
        this._confidenceThreshold = confidenceThreshold;
    }
    /**
     * The confidence threshold for labels returned by the label detector. Features returned by the
     * label detector will have a confidence higher or equal to the confidence threshold. Default value
     * is 0.5.
     */
    public function get confidenceThreshold():Number {
        return _confidenceThreshold;
    }
}
}
