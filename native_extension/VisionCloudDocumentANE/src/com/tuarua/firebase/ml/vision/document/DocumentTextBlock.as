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
import com.tuarua.fre.ANEError;

import flash.geom.Rectangle;

public class DocumentTextBlock {
    /** @private */
    private var _id:String;
    /** @private */
    private var _index:uint;
    /**
     * The rectangle that contains the document text block relative to the image in the default
     * coordinate space.
     */
    public var frame:Rectangle;
    /**
     * String representation of the document text block that was recognized.
     */
    public var text:String;
    /**
     * The detected block type.
     */
    public var type:uint;

    private var _paragraphs:Vector.<DocumentTextParagraph> = new <DocumentTextParagraph>[];
    /**
     * The confidence of the recognized document text block.
     */
    public var confidence:Number;
    /**
     * An array of recognized languages in the document text block. If no languages are recognized, the
     * array is empty.
     */
    public var recognizedLanguages:Vector.<TextRecognizedLanguage> = new <TextRecognizedLanguage>[];
    /**
     * The recognized start or end of the document text block.
     */
    public var recognizedBreak:RecognizedBreak;

    /** @private */
    public function DocumentTextBlock(id:String, index:uint) {
        this._id = id;
        this._index = index;
    }

    /**
     * An array of paragraphs in the block if the type is <code>DocumentBlockType.text</code>. Otherwise,
     * the array is empty.
     */
    public function get paragraphs():Vector.<DocumentTextParagraph> {
        if (_paragraphs.length > 0) return _paragraphs;
        var ret:* = CloudDocumentTextRecognizer.context.call("getParagraphs", this._id, this._index);
        if (ret is ANEError) throw ret as ANEError;
        if (ret != null) _paragraphs = ret;
        return _paragraphs;
    }
}
}