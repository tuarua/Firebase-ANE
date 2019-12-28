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
import com.sociodox.utils.Base64;
import com.tuarua.firebase.storage.StorageError;
import com.tuarua.firebase.storage.StorageMetadata;
import com.tuarua.firebase.storage.StorageTask;
import com.tuarua.firebase.storage.events.StorageErrorEvent;
import com.tuarua.firebase.storage.events.StorageEvent;
import com.tuarua.firebase.storage.events.StorageProgressEvent;
import com.tuarua.fre.ANEUtils;

import flash.external.ExtensionContext;
import flash.events.StatusEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
/** @private */
public class StorageANEContext {
    internal static const NAME:String = "StorageANE";
    internal static const TRACE:String = "TRACE";
    private static var _isInited:Boolean = false;
    private static const INIT_ERROR_MESSAGE:String = NAME + "... use .storage";
    private static const DELETED:String = "StorageEvent.Deleted";
    private static const GET_METADATA:String = "StorageEvent.GetMetadata";
    private static const GET_DOWNLOAD_URL:String = "StorageEvent.GetDownloadUrl";
    private static const UPDATE_METADATA:String = "StorageEvent.UpdateMetadata";
    private static var _context:ExtensionContext;
    public static var listeners:Vector.<Object> = new <Object>[];
    public static var listenersObjects:Dictionary = new Dictionary();
    private static var listenersObject:* = null;
    public static var tasks:Dictionary = new Dictionary();
    public static var callbacks:Dictionary = new Dictionary();
    private static var argsAsJSON:Object;

    public function StorageANEContext() {

    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }

        return _context;
    }

    public static function createCallback(listener:Function):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
        }
        return id;
    }

    public static function callCallback(callbackId:String, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function getListenerObject(type:String, callbackId:String):* {
        var length:int = listeners.length;
        var obj:Object;
        for (var i:int = 0; i < length; ++i) {
            obj = listeners[i];
            if (obj.type == type && obj.id == callbackId) {
                return listenersObjects[callbackId];
            }
        }
    }

    private static function getListener(type:String, callbackId:String):Function {
        var length:int = listeners.length;
        var obj:Object;
        for (var i:int = 0; i < length; ++i) {
            obj = listeners[i];
            if (obj.type == type && obj.id == callbackId) {
                return obj.listener;
            }
        }
        return null;
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:StorageError;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case StorageEvent.TASK_COMPLETE:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, argsAsJSON.callbackId);
                    if (listenersObject == null) return;
                    var file:File;
                    var ba:ByteArray;

                    if (argsAsJSON.data) {
                        if (argsAsJSON.data.hasOwnProperty("b64")) {
                            var b64:String = argsAsJSON.data.b64;
                            if (b64) ba = Base64.decode(b64);
                        } else if (argsAsJSON.data.localPath != null) {
                            file = new File(argsAsJSON.data.localPath);
                        }
                    }
                    listenersObject.dispatchEvent(new StorageEvent(event.level, file, ba));
                    var lstner:Function = getListener(event.level, argsAsJSON.callbackId);
                    if (lstner != null) {
                        listenersObject.removeEventListener(event.level, lstner);
                    }
                    lstner = getListener(StorageErrorEvent.ERROR, argsAsJSON.callbackId);
                    if (lstner != null) {
                        listenersObject.removeEventListener(StorageErrorEvent.ERROR, lstner);
                    }
                    lstner = getListener(StorageProgressEvent.PROGRESS, argsAsJSON.callbackId);
                    if (lstner != null) {
                        listenersObject.removeEventListener(StorageProgressEvent.PROGRESS, lstner);
                    }
                } catch (e:Error) {
                    trace(e.errorID, e.message);
                }
                break;

            case StorageProgressEvent.PROGRESS:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, argsAsJSON.callbackId);
                    if (listenersObject == null) return;
                    if (listenersObject is StorageTask) {
                        (listenersObject as StorageTask).dispatchEvent(
                                new StorageProgressEvent(event.level, false, false, argsAsJSON.bytesLoaded, argsAsJSON.bytesTotal)
                        );
                    }
                } catch (e:Error) {
                    trace(e.errorID, e.message);
                }
                break;

            case GET_METADATA:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var metadata:StorageMetadata;
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new StorageError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty("data")) {
                        metadata = ANEUtils.map(argsAsJSON.data.data, StorageMetadata) as StorageMetadata;
                    }
                    callCallback(argsAsJSON.callbackId, metadata, err);
                } catch (e:Error) {
                    trace(event.code, e.message);
                }
                break;

            case StorageErrorEvent.ERROR:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, argsAsJSON.callbackId);
                    if (listenersObject == null) return;
                    listenersObject.dispatchEvent(new StorageErrorEvent(event.level, true, false, argsAsJSON.text, argsAsJSON.id));
                } catch (e:Error) {
                    trace(e.errorID, e.message);
                }
                break;

            case GET_DOWNLOAD_URL:
                argsAsJSON = JSON.parse(event.code);
                var url:String;
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    err = new StorageError(argsAsJSON.error.text, argsAsJSON.error.id);
                } else if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty("url")) {
                    url = argsAsJSON.data.url;
                }
                callCallback(argsAsJSON.callbackId, url, err);
                break;
            case UPDATE_METADATA:
                argsAsJSON = JSON.parse(event.code);
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    err = new StorageError(argsAsJSON.error.text, argsAsJSON.error.id);
                }
                callCallback(argsAsJSON.callbackId, err);
                break;
            case DELETED:
                argsAsJSON = JSON.parse(event.code);
                var localPath:String;
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    err = new StorageError(argsAsJSON.error.text, argsAsJSON.error.id);
                } else if (argsAsJSON.hasOwnProperty("data")
                        && argsAsJSON.data
                        && argsAsJSON.data.hasOwnProperty("localPath")) {
                    localPath = argsAsJSON.data.localPath;
                }
                callCallback(argsAsJSON.callbackId, localPath, err);
                break;
        }
    }


    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }
}
}
