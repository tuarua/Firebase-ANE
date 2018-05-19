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

    public static var closures:Dictionary = new Dictionary();

    private static var pObj:Object;

    public function StorageANEContext() {

    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
            }
        }

        return _context;
    }

    public static function createEventId(listener:Function):String {
        var eventId:String;
        if (listener) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    private static function getListenerObject(type:String, eventId:String):* {
        var length:int = listeners.length;
        var obj:Object;
        for (var i:int = 0; i < length; ++i) {
            obj = listeners[i];
            if (obj.type == type && obj.id == eventId) {
                return listenersObjects[eventId];
            }
        }
    }

    private static function getListener(type:String, eventId:String):Function {
        var length:int = listeners.length;
        var obj:Object;
        for (var i:int = 0; i < length; ++i) {
            obj = listeners[i];
            if (obj.type == type && obj.id == eventId) {
                return obj.listener;
            }
        }
        return null;
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:StorageError;
        var closure:Function;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case StorageEvent.TASK_COMPLETE:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    var file:File;
                    var ba:ByteArray;

                    if (pObj.data) {
                        if (pObj.data.hasOwnProperty("b64")) {
                            var b64:String = pObj.data.b64;
                            if (b64) ba = Base64.decode(b64);
                        } else if (pObj.data.localPath != null) {
                            file = new File(pObj.data.localPath);
                        }
                    }
                    listenersObject.dispatchEvent(new StorageEvent(event.level, file, ba));
                    var lstner:Function = getListener(event.level, pObj.eventId);
                    if (lstner) {
                        listenersObject.removeEventListener(event.level, lstner);
                    }
                    lstner = getListener(StorageErrorEvent.ERROR, pObj.eventId);
                    if (lstner) {
                        listenersObject.removeEventListener(StorageErrorEvent.ERROR, lstner);
                    }
                    lstner = getListener(StorageProgressEvent.PROGRESS, pObj.eventId);
                    if (lstner) {
                        listenersObject.removeEventListener(StorageProgressEvent.PROGRESS, lstner);
                    }
                } catch (e:Error) {
                    trace(e.errorID, e.message);
                }
                break;

            case StorageProgressEvent.PROGRESS:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    if (listenersObject is StorageTask) {
                        (listenersObject as StorageTask).dispatchEvent(
                                new StorageProgressEvent(event.level, false, false, pObj.bytesLoaded, pObj.bytesTotal)
                        );
                    }
                } catch (e:Error) {
                    trace(e.errorID, e.message);
                }
                break;

            case GET_METADATA:
                try {
                    pObj = JSON.parse(event.code);
                    var metadata:StorageMetadata;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new StorageError(pObj.error.text, pObj.error.id);
                    } else if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("data")) {
                        metadata = ANEUtils.map(pObj.data.data, StorageMetadata) as StorageMetadata;
                    }
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    closure.call(null, metadata, err);
                    delete closures[pObj.eventId];
                } catch (e:Error) {
                    trace(event.code, e.message);
                }
                break;

            case StorageErrorEvent.ERROR:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    listenersObject.dispatchEvent(new StorageErrorEvent(event.level, true, false, pObj.text, pObj.id));
                } catch (e:Error) {
                    trace(e.errorID, e.message);
                }
                break;

            case GET_DOWNLOAD_URL:
                pObj = JSON.parse(event.code);
                var url:String;
                if (pObj.hasOwnProperty("error") && pObj.error) {
                    err = new StorageError(pObj.error.text, pObj.error.id);
                } else if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("url")) {
                    url = pObj.data.url;
                }
                closure = closures[pObj.eventId];
                if (closure == null) return;
                closure.call(null, url, err);
                delete closures[pObj.eventId];
                break;
            case UPDATE_METADATA:
                pObj = JSON.parse(event.code);
                if (pObj.hasOwnProperty("error") && pObj.error) {
                    err = new StorageError(pObj.error.text, pObj.error.id);
                }
                closure = closures[pObj.eventId];
                if (closure == null) return;
                closure.call(null, err);
                delete closures[pObj.eventId];
                break;
            case DELETED:
                pObj = JSON.parse(event.code);
                var localPath:String;
                if (pObj.hasOwnProperty("error") && pObj.error) {
                    err = new StorageError(pObj.error.text, pObj.error.id);
                } else if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("localPath")) {
                    localPath = pObj.data.localPath;
                }
                closure = closures[pObj.eventId];
                if (closure == null) return;
                closure.call(null, localPath, err);
                delete closures[pObj.eventId];
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
