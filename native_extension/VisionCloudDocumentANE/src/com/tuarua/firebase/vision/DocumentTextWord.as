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
import flash.geom.Rectangle;

/**
 * A document text word recognized in an image that consists of an array of symbols.
 */
public class DocumentTextWord {
    /**
     * The rectangle that contains the document text word relative to the image in the default
     * coordinate space.
     */
    public var frame:Rectangle;
    /**
     * String representation of the document text word that was recognized.
     */
    public var text:String;
    /**
     * The confidence of the recognized document text word.
     */
    public var confidence:Number;
    /**
     * The recognized start or end of the document text word.
     */
    public var recognizedBreak:TextRecognizedBreak;
    /**
     * An array of recognized languages in the document text word. If no languages are recognized, the
     * array is empty.
     */
    public var recognizedLanguages:Vector.<TextRecognizedLanguage> = new <TextRecognizedLanguage>[];
    /**
     * An array of symbols in the document text word.
     */
    public var symbols:Vector.<DocumentTextSymbol> = new <DocumentTextSymbol>[];

    /** @private */
    public function DocumentTextWord() {
    }
}
}