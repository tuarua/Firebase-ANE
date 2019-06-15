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

package com.tuarua.firebase.ml.vision.barcode {
[RemoteClass(alias="com.tuarua.firebase.ml.vision.barcode.BarcodePhone")]
/**
 * A phone number from a 'TEL:' or similar QR Code type.
 */
public class BarcodePhone {
    private var _number:String;
    private var _type:int;
    /** @private */
    public function BarcodePhone(number:String, type:int) {
        this._number = number;
        this._type = type;
    }

    /**
     * Phone number.
     */
    public function get number():String {
        return _number;
    }
    /**
     * Phone number type.
     */
    public function get type():int {
        return _type;
    }
}
}
