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

public class Storage extends EventDispatcher {
    private static var _shared:Storage;
    private static var _url:String;
    /** @private */
    public function Storage() {
        if (StorageANEContext.context) {
            var ret:* = StorageANEContext.context.call("init", _url);
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    /** @private */
    public static function get shared():Storage {
        if (!_shared) {
            new Storage();
        }
        return _shared;
    }

    public function reference(path:String = null, url:String = null):StorageReference {
        StorageANEContext.validate();
        return new StorageReference(path, url);
    }

    public function get maxDownloadRetryTime():Number {
        StorageANEContext.validate();
        var ret:* = StorageANEContext.context.call("getMaxDownloadRetryTime");
        if (ret is ANEError) {
            throw ret as ANEError;
        }
        return ret as Number;
    }

    public function get maxUploadRetryTime():Number {
        StorageANEContext.validate();
        var ret:* = StorageANEContext.context.call("getMaxUploadRetryTime");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Number;
    }

    public function get maxOperationRetryTime():Number {
        StorageANEContext.validate();
        var ret:* = StorageANEContext.context.call("getMaxOperationRetryTime");
        if (ret is ANEError) throw ret as ANEError;
        return ret as Number;
    }

    /**
     * Maximum time in seconds to retry a download if a failure occurs.
     * Defaults to 10 minutes (600000 milliseconds).
     */
    public function set maxDownloadRetryTime(value:Number):void {
        StorageANEContext.validate();
        var ret:* = StorageANEContext.context.call("setMaxDownloadRetryTime", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Maximum time in seconds to retry operations other than upload and download if a failure occurs.
     * Defaults to 2 minutes (120000 milliseconds).
     */
    public function set maxOperationRetryTime(value:Number):void {
        StorageANEContext.validate();
        var ret:* = StorageANEContext.context.call("setMaxOperationRetryTime", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Maximum time in seconds to retry an upload if a failure occurs.
     * Defaults to 10 minutes (600000 milliseconds).
     */
    public function set maxUploadRetryTime(value:Number):void {
        StorageANEContext.validate();
        var ret:* = StorageANEContext.context.call("setMaxUploadRetryTime", value);
        if (ret is ANEError) throw ret as ANEError;
    }

    /** The gs:// url to your Firebase Storage Bucket. */
    public static function set url(value:String):void {
        _url = value;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (StorageANEContext.context) {
            StorageANEContext.dispose();
        }
    }

}
}
