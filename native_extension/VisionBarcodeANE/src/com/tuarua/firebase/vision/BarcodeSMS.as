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
[RemoteClass(alias="com.tuarua.firebase.vision.BarcodeSMS")]
public class BarcodeSMS {
    private var _message:String;
    private var _phoneNumber:String;

    public function BarcodeSMS(message:String, phoneNumber:String) {
        this._message = message;
        this._phoneNumber = phoneNumber;
    }

    public function get message():String {
        return _message;
    }

    public function get phoneNumber():String {
        return _phoneNumber;
    }
}
}