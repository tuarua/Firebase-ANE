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

    /*
    service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
     */

    public function getReference(path:String = null, url:String = null):StorageReference {
        if (!_storage) throw new Error(INIT_ERROR_MESSAGE);
        return new StorageReference(path, url);
    }

    public static function dispose():void {
        if (StorageANEContext.context) {
            StorageANEContext.dispose();
        }
    }

//    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
//        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
//    }
//
//    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
//        super.removeEventListener(type, listener, useCapture);
//    }

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
