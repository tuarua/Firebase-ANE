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

package com.tuarua.firebase {
import com.tuarua.firebase.storage.StorageReference;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class StorageANE extends EventDispatcher {
    private static var _storage:StorageANE;
    private static var _url:String;
    private static const INIT_ERROR_MESSAGE:String = "StorageANE... use .firestore";

    public function StorageANE() {
        if (_storage) {
            throw new Error(StorageANEContext.NAME + " use .firestore");
        }
        if (StorageANEContext.context) {
            var theRet:* = StorageANEContext.context.call("init", _url);
            if (theRet is ANEError) {
                throw theRet as ANEError;
            }
        }
        _storage = this;
    }

    public static function get storage():StorageANE {
        if (!_storage) {
            new StorageANE();
        }
        return _storage;
    }

    public function getReference(path:String = null, url:String = null):StorageReference {
        if (!_storage) throw new Error(INIT_ERROR_MESSAGE);
        return new StorageReference(path, url);
    }

    public static function dispose():void {
        if (StorageANEContext.context) {
            StorageANEContext.dispose();
        }
    }

    public function get maxDownloadRetryTime():Number {
        var theRet:* = StorageANEContext.context.call("getMaxDownloadRetryTime");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as Number;
    }

    public function get maxUploadRetryTime():Number {
        var theRet:* = StorageANEContext.context.call("getMaxUploadRetryTime");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as Number;
    }

    public function get maxOperationRetryTime():Number {
        var theRet:* = StorageANEContext.context.call("getMaxOperationRetryTime");
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        return theRet as Number;
    }

    public function set maxDownloadRetryTime(value:Number):void {
        var theRet:* = StorageANEContext.context.call("setMaxDownloadRetryTime", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set maxOperationRetryTime(value:Number):void {
        var theRet:* = StorageANEContext.context.call("setMaxOperationRetryTime", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function set maxUploadRetryTime(value:Number):void {
        var theRet:* = StorageANEContext.context.call("setMaxUploadRetryTime", value);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public static function set url(value:String):void {
        _url = value;
    }
}
}
