/*
 * Copyright 2019 Tua Rua Ltd.
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

package com.tuarua.firebase.naturalLanguage {
public class LanguageIdentificationOptions {
    private var _confidenceThreshold:Number = 0.5;

    /**
     * Creates a new instance of language identification options with the given confidence threshold.
     *
     * @param confidenceThreshold The confidence threshold for language identification.
     *
     * @return A new instance of `LanguageIdentificationOptions` with the given confidence threshold.
     */
    public function LanguageIdentificationOptions(confidenceThreshold:Number = 0.5) {
        this._confidenceThreshold = confidenceThreshold;
    }

    /**
     * The confidence threshold for language identification. The identified languages will have a
     * confidence higher or equal to the confidence threshold. The value should be between 0 and 1.
     * If an invalid value is set, the default value is used instead. The default value for identifying
     * the main language is 0.5 and for identifying possible
     * languages is 0.01.
     */
    public function get confidenceThreshold():Number {
        return _confidenceThreshold;
    }
}
}
