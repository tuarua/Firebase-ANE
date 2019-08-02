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
[RemoteClass(alias="com.tuarua.firebase.ml.vision.barcode.BarcodeWifi")]
/**
 * Wi-Fi network parameters from a 'WIFI:' or similar QR Code type.
 */
public class BarcodeWifi {
    private var _password:String;
    private var _ssid:String;
    private var _type:int;

    /** @private */
    public function BarcodeWifi(password:String, ssid:String, type:int) {
        this._password = password;
        this._ssid = ssid;
        this._type = type;
    }

    /**
     * A Wi-Fi access point password.
     */
    public function get password():String {
        return _password;
    }

    /**
     * A Wi-Fi access point SSID.
     */
    public function get ssid():String {
        return _ssid;
    }

    /**
     * A Wi-Fi access point encryption type.
     */
    public function get type():int {
        return _type;
    }
}
}