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

package com.tuarua.mlkit.vision.barcode {
[RemoteClass(alias="com.tuarua.mlkit.vision.barcode.BarcodeURLBookmark")]
/**
 * A URL and title from a 'MEBKM:' or similar QR Code type.
 */
public class BarcodeURLBookmark {
    private var _title:String;
    private var _url:String;

    /** @private */
    public function BarcodeURLBookmark(title:String, url:String) {
        this._title = title;
        this._url = url;
    }

    /**
     * A URL bookmark title.
     */
    public function get title():String {
        return _title;
    }

    /**
     * A URL bookmark url.
     */
    public function get url():String {
        return _url;
    }
}
}