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
import com.tuarua.firebase.CloudDocumentRecognizer;
import com.tuarua.fre.ANEError;

import flash.geom.Rectangle;

/**
 * A document text paragraph recognized in an image that consists of an array of words.
 */
public class DocumentTextParagraph {
    /** @private */
    private var _id:String;
    /** @private */
    private var _blockIndex:uint;
    /** @private */
    private var _index:uint;
    /**
     * The rectangle that contains the document text paragraph relative to the image in the default
     * coordinate space.
     */
    public var frame:Rectangle;
    /**
     * String representation of the document text paragraph that was recognized.
     */
    public var text:String;
    /**
     * The confidence of the recognized document text paragraph.
     */
    public var confidence:Number;
    /** @private */
    private var _words:Vector.<DocumentTextWord> = new <DocumentTextWord>[];
    /**
     * An array of recognized languages in the document text paragraph. If no languages are recognized,
     * the array is empty.
     */
    public var recognizedLanguages:Vector.<TextRecognizedLanguage> = new <TextRecognizedLanguage>[];
    /**
     * The recognized start or end of the document text paragraph.
     */
    public var recognizedBreak:TextRecognizedBreak;

    /** @private */
    public function DocumentTextParagraph(id: String, blockIndex: uint, index: uint) {
        this._id = id;
        this._blockIndex = blockIndex;
        this._index = index;
    }
    /**
     * An array of words in the document text paragraph.
     */
    public function get words():Vector.<DocumentTextWord> {
        if (_words.length > 0) return _words;
        var ret:* = CloudDocumentRecognizer.context.call("getWords", this._id, this._blockIndex, this._index);
        if (ret is ANEError) throw ret as ANEError;
        if (ret != null) _words = ret;
        return _words;
    }
}
}
