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

package com.tuarua.firebase.firestore {
[RemoteClass(alias="com.tuarua.firebase.firestore.Where")]
public class Where {
    private var _fieldPath:String;
    private var _operator:String;
    private var _value:*;

    public function Where(fieldPath:String, operator:String, value:*) {
        this._fieldPath = fieldPath;
        this._operator = operator;
        this._value = value;
    }

    public function get fieldPath():String {
        return _fieldPath;
    }

    public function get operator():String {
        return _operator;
    }

    public function get value():* {
        return _value;
    }
}
}
