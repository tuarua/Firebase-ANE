/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua.firebase.vision {
import flash.geom.Rectangle;

[RemoteClass(alias="com.tuarua.firebase.vision.CloudParagraph")]
/**
 * A paragraph consisting of `CloudWord` objects in a certain order.
 */
public class CloudParagraph {
    /**
     * Confidence of the OCR results for the paragraph. The value is a float, in range [0, 1].
     */
    public var confidence:Number;
    /**
     * A rectangle image region to which this landmark belongs to (in the view coordinate system).
     */
    public var frame:Rectangle;
    /**
     * Additional information detected for the paragraph.
     */
    public var textProperty:CloudTextProperty;
    /**
     * An array of words in the paragraph.
     */
    public var words:Vector.<CloudWord> = new <CloudWord>[];
    /** @private */
    public function CloudParagraph() {
    }
}
}