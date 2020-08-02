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

package com.tuarua.firebase.ml.vision.text {
[RemoteClass(alias="com.tuarua.firebase.ml.vision.text.TextRecognizedLanguage")]
/**
 * Detected language from text recognition.
 */
public class CloudTextRecognizedLanguage {
    /**
     *  The BCP-47 language code, such as, "en-US" or "sr-Latn". For more information, see
     *  http://www.unicode.org/reports/tr35/#Unicode_locale_identifier.
     */
    public var languageCode:String;
    /** @private */
    public function CloudTextRecognizedLanguage() {
    }
}
}
