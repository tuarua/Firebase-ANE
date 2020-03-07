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
import com.tuarua.firebase.firestore.DocumentChange;
import com.tuarua.firebase.firestore.DocumentSnapshot;
import com.tuarua.firebase.firestore.FirestoreError;
import com.tuarua.firebase.firestore.QuerySnapshot;
import com.tuarua.firebase.firestore.SnapshotMetadata;
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;
/** @private */
public class FirestoreANEContext {
    internal static const NAME:String = "FirestoreANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .firestore";

    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    public static var callbackCallers:Dictionary = new Dictionary();

    private static const NETWORK_ENABLED:String = "NetworkEvent.Enabled";
    private static const NETWORK_DISABLED:String = "NetworkEvent.Disabled";
    private static const DOCUMENT_UPDATED:String = "DocumentEvent.Updated";
    private static const DOCUMENT_SET:String = "DocumentEvent.Set";
    private static const DOCUMENT_DELETED:String = "DocumentEvent.Deleted";
    private static const DOCUMENT_SNAPSHOT:String = "DocumentEvent.Snapshot";
    private static const QUERY_SNAPSHOT:String = "QueryEvent.QuerySnapshot";
    private static const BATCH_COMPLETE:String = "BatchEvent.Complete";

    private static var argsAsJSON:Object;

    public function FirestoreANEContext() {
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

    public static function createCallback(listener:Function, listenerCaller:Object = null):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
            if (listenerCaller) {
                callbackCallers[id] = listenerCaller;
            }
        }
        return id;
    }

    public static function callCallback(callbackId:String, clear:Boolean, ... args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        if (clear) {
            delete callbacks[callbackId];
            delete callbackCallers[callbackId];
        }
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:FirestoreError;
        var path:String;
        var callbackCaller:*;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case DOCUMENT_SNAPSHOT:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    var snap:DocumentSnapshot;
                    callbackCaller = callbackCallers[argsAsJSON.callbackId];
                    if (callbackCaller == null) return;
                    var data:Object;
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new FirestoreError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty("data")) {
                        data = argsAsJSON.data.data;
                    }

                    if (callbackCaller.mapTo) {
                        data = ANEUtils.map(argsAsJSON.data.data, callbackCaller.mapTo) as callbackCaller.mapTo;
                    }

                    snap = new DocumentSnapshot(argsAsJSON.data.id,
                            data,
                            argsAsJSON.data.exists,
                            ANEUtils.map(argsAsJSON.data.metadata, SnapshotMetadata) as SnapshotMetadata);

                    callCallback(argsAsJSON.callbackId, !argsAsJSON.realtime, snap, err, argsAsJSON.realtime);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case QUERY_SNAPSHOT:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    callbackCaller = callbackCallers[argsAsJSON.callbackId];
                    if (callbackCaller == null) return;
                    var querySnapshot:QuerySnapshot;
                    var data_ab:Object;

                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new FirestoreError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty("documents")) {
                        querySnapshot = new QuerySnapshot();
                        var docs:Vector.<DocumentSnapshot> = new <DocumentSnapshot>[];
                        var docChanges:Vector.<DocumentChange> = new <DocumentChange>[];
                        for each(var doc_ab:Object in argsAsJSON.data.documents) {
                            data_ab = doc_ab.data;
                            if (callbackCaller.mapTo) {
                                data_ab = ANEUtils.map(doc_ab.data, callbackCaller.mapTo) as callbackCaller.mapTo;
                            }
                            docs.push(new DocumentSnapshot(
                                    doc_ab.id,
                                    data_ab,
                                    doc_ab.exists,
                                    ANEUtils.map(doc_ab.metadata, SnapshotMetadata) as SnapshotMetadata
                            ));
                        }
                        for each (var change_aa:Object in argsAsJSON.data.documentChanges) {
                            docChanges.push(ANEUtils.map(change_aa, DocumentChange) as DocumentChange);
                        }
                        querySnapshot.documents = docs;
                        querySnapshot.documentChanges = docChanges;
                        querySnapshot.metadata = ANEUtils.map(argsAsJSON.data.metadata, SnapshotMetadata) as SnapshotMetadata;
                    }
                    callCallback(argsAsJSON.callbackId, false, querySnapshot, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case BATCH_COMPLETE:
            case NETWORK_ENABLED:
            case NETWORK_DISABLED:
                argsAsJSON = JSON.parse(event.code);
                if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                    err = new FirestoreError(argsAsJSON.error.text, argsAsJSON.error.id);
                }
                callCallback(argsAsJSON.callbackId, true, err);
                break;
            case DOCUMENT_DELETED:
            case DOCUMENT_UPDATED:
            case DOCUMENT_SET:
                try {
                    argsAsJSON = JSON.parse(event.code);
                    if (argsAsJSON.hasOwnProperty("error") && argsAsJSON.error) {
                        err = new FirestoreError(argsAsJSON.error.text, argsAsJSON.error.id);
                    } else if (argsAsJSON.hasOwnProperty("data") && argsAsJSON.data && argsAsJSON.data.hasOwnProperty("path")) {
                        path = argsAsJSON.data.path;
                    }
                    callCallback(argsAsJSON.callbackId, true, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
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
