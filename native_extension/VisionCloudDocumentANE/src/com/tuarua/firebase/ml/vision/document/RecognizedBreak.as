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

package com.tuarua.firebase.ml.vision.document {
/**
 * Detected break from text recognition.
 */
public class RecognizedBreak {
    /**
     *  The recognized text break type.
     */
    public var type:uint;
    /**
     * Indicates whether the break prepends the text element. If <code>false</code>, the break comes after the text
     * element.
     */
    public var isPrefix:Boolean;

    /** @private */
    public function RecognizedBreak() {
    }
}
}
