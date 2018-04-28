package com.tuarua.firebase {
import com.sociodox.utils.Base64;
import com.tuarua.firebase.storage.DownloadTask;
import com.tuarua.firebase.storage.StorageMetadata;
import com.tuarua.firebase.storage.StorageReference;
import com.tuarua.firebase.storage.StorageTask;
import com.tuarua.firebase.storage.UploadTask;
import com.tuarua.firebase.storage.events.StorageErrorEvent;
import com.tuarua.firebase.storage.events.StorageEvent;
import com.tuarua.firebase.storage.events.StorageProgressEvent;
import com.tuarua.fre.ANEUtils;
import com.tuarua.fre.ANEUtils;

import flash.external.ExtensionContext;
import flash.events.StatusEvent;
import flash.filesystem.File;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class StorageANEContext {
    internal static const NAME:String = "StorageANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;

    public static var listeners:Vector.<Object> = new <Object>[];
    public static var listenersObjects:Dictionary = new Dictionary();
    private static var listenersObject:* = null;
    public static var tasks:Dictionary = new Dictionary();

    private static var pObj:Object;

    public function StorageANEContext() {

    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    private static function getListenerObject(type:String, eventId:String):* {
        for each (var item_aa:Object in listeners) {
            if (item_aa.type == type && item_aa.id == eventId) {
                return listenersObjects[eventId];
            }
        }
    }

    private static function gotEvent(event:StatusEvent):void {

        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case StorageEvent.COMPLETE:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    if (listenersObject is UploadTask) {
                        var file_ab:File;
                        if (pObj.data != null && pObj.data.localPath != null) {
                            file_ab = new File(pObj.data.localPath);
                        }
                        (listenersObject as UploadTask).dispatchEvent(new StorageEvent(event.level, file_ab));
                    } else if (listenersObject is DownloadTask) {
                        if (pObj.data.hasOwnProperty("b64")) {
                            var b64:String = pObj.data.b64;
                            var ba:ByteArray;
                            if (b64) ba = Base64.decode(b64);
                            (listenersObject as DownloadTask).dispatchEvent(new StorageEvent(event.level, null, ba));
                        } else {
                            var file_ad:File;
                            if (pObj.data != null && pObj.data.localPath != null) {
                                file_ad = new File(pObj.data.localPath);
                            }
                            (listenersObject as DownloadTask).dispatchEvent(new StorageEvent(event.level, file_ad));
                        }
                    } else if (listenersObject is StorageReference) {
                        var file_ac:File;
                        if (pObj.data != null && pObj.data.localPath != null) {
                            file_ac = new File(pObj.data.localPath);
                        }
                        (listenersObject as StorageReference).dispatchEvent(new StorageEvent(event.level, file_ac));
                    }
                } catch (e:Error) {
                    trace(event.code, e.message);
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
                    trace(event.code, e.message);
                }
                break;
            case StorageEvent.GET_DOWNLOAD_URL:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    (listenersObject as StorageReference).dispatchEvent(new StorageEvent(event.level, null, null, pObj.data.url));
                } catch (e:Error) {
                    trace(event.code, e.message);
                }
                break;
            case StorageEvent.GET_METADATA:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    var o:Object = pObj.data.data;
                    var metadata:StorageMetadata;
                    if (o) metadata = ANEUtils.map(o, StorageMetadata) as StorageMetadata;
                    (listenersObject as StorageReference).dispatchEvent(new StorageEvent(event.level, null, null, null, metadata));
                } catch (e:Error) {
                    trace(event.code, e.message);
                }
                break;
            case StorageEvent.UPDATE_METADATA:
                pObj = JSON.parse(event.code);
                listenersObject = getListenerObject(event.level, pObj.eventId);
                if (listenersObject == null) return;
                (listenersObject as StorageReference).dispatchEvent(new StorageEvent(event.level, null, null, null, metadata));
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
    }
}
}
