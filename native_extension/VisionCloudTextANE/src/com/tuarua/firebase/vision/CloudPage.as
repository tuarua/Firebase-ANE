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
[RemoteClass(alias="com.tuarua.firebase.vision.CloudPage")]
/**
 * A page consisting of CloudBlock objects.
 */
public class CloudPage {
    /**
     * Confidence of the OCR results on the page. The value is a float, in range [0, 1].
     */
    public var confidence:Number;
    /**
     * The page width. For PDFs, the unit is points. For images (including TIFFs) the unit is pixels.
     * The value is an int.
     */
    public var width:Number;
    /**
     * The page height. For PDFs, the unit is points. For images (including TIFFs) the unit is pixels.
     * The value is an int.
     */
    public var height:Number;
    /**
     * Additional information detected for the page.
     */
    public var textProperty:CloudTextProperty;
    /**
     * An array of blocks (text, image, etc.) on the page.
     */
    public var blocks:Vector.<CloudBlock> = new <CloudBlock>[];
    /** @private */
    public function CloudPage() {
    }
}
}