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
import com.tuarua.firebase.ml.vision.text.TextRecognizedLanguage;

import flash.geom.Rectangle;

/**
 * A document text symbol recognized in an image.
 */
public class DocumentTextSymbol {
    /**
     * The rectangle that contains the document text symbol relative to the image in the default
     * coordinate space.
     */
    public var frame:Rectangle;
    /**
     * String representation of the document text symbol that was recognized.
     */
    public var text:String;
    /**
     * The confidence of the recognized document text symbol.
     */
    public var confidence:Number;
    /**
     * The recognized start or end of the document text symbol.
     */
    public var recognizedBreak:RecognizedBreak;
    /**
     * An array of recognized languages in the document text symbol. If no languages are recognized, the
     * array is empty.
     */
    public var recognizedLanguages:Vector.<TextRecognizedLanguage> = new <TextRecognizedLanguage>[];

    /** @private */
    public function DocumentTextSymbol() {
    }
}
}