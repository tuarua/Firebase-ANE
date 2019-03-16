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
[RemoteClass(alias="com.tuarua.firebase.naturalLanguage.IdentifiedLanguage")]
public class IdentifiedLanguage {
    /**
     * The confidence score of the language.
     */
    public var confidence:Number;
    /**
     * The BCP-47 language code for the language.
     */
    public var languageCode:String;

    public function IdentifiedLanguage() {
    }
}
}
