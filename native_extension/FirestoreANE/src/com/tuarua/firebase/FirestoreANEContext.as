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
    public static var closures:Dictionary = new Dictionary();
    public static var closureCallers:Dictionary = new Dictionary();

    private static const NETWORK_ENABLED:String = "NetworkEvent.Enabled";
    private static const NETWORK_DISABLED:String = "NetworkEvent.Disabled";
    private static const DOCUMENT_UPDATED:String = "DocumentEvent.Updated";
    private static const DOCUMENT_SET:String = "DocumentEvent.Set";
    private static const DOCUMENT_DELETED:String = "DocumentEvent.Deleted";
    private static const DOCUMENT_SNAPSHOT:String = "DocumentEvent.Snapshot";
    private static const QUERY_SNAPSHOT:String = "QueryEvent.QuerySnapshot";
    private static const BATCH_COMPLETE:String = "BatchEvent.Complete";

    private static var pObj:Object;

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

    public static function createEventId(listener:Function, listenerCaller:Object = null):String {
        var eventId:String;
        if (listener) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
            if (closureCallers) {
                closureCallers[eventId] = listenerCaller;
            }
        }
        return eventId;
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:FirestoreError;
        var path:String;
        var closure:Function;
        var closureObject:*;
        trace(event.code);
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case DOCUMENT_SNAPSHOT:
                try {
                    pObj = JSON.parse(event.code);
                    var snap:DocumentSnapshot;
                    closureObject = closureCallers[pObj.eventId];
                    if (closureObject == null) return;
                    closure = closures[pObj.eventId];
                    if (closure == null) return;

                    var data:Object;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new FirestoreError(pObj.error.text, pObj.error.id);
                    } else if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("data")) {
                        data = pObj.data.data;
                    }

                    if (closureObject.mapTo) {
                        data = ANEUtils.map(pObj.data.data, closureObject.mapTo) as closureObject.mapTo;
                    }

                    snap = new DocumentSnapshot(pObj.data.id,
                            data,
                            pObj.data.exists,
                            ANEUtils.map(pObj.data.metadata, SnapshotMetadata) as SnapshotMetadata);
                    closure.call(null, snap, err, pObj.realtime);
                    if (!pObj.realtime) {
                        delete closures[pObj.eventId];
                        delete closureCallers[pObj.eventId];
                    }
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case QUERY_SNAPSHOT:
                try {
                    pObj = JSON.parse(event.code);
                    closureObject = closureCallers[pObj.eventId];
                    if (closureObject == null) return;
                    closure = FirestoreANEContext.closures[pObj.eventId];
                    if (closure == null) return;
                    var querySnapshot:QuerySnapshot;
                    var data_ab:Object;

                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new FirestoreError(pObj.error.text, pObj.error.id);
                    } else if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("documents")) {
                        querySnapshot = new QuerySnapshot();
                        var docs:Vector.<DocumentSnapshot> = new <DocumentSnapshot>[];
                        var docChanges:Vector.<DocumentChange> = new <DocumentChange>[];
                        for each(var doc_ab:Object in pObj.data.documents) {
                            data_ab = doc_ab.data;
                            if (closureObject.mapTo) {
                                data_ab = ANEUtils.map(doc_ab.data, closureObject.mapTo) as closureObject.mapTo;
                            }
                            docs.push(new DocumentSnapshot(
                                    doc_ab.id,
                                    data_ab,
                                    doc_ab.exists,
                                    ANEUtils.map(doc_ab.metadata, SnapshotMetadata) as SnapshotMetadata
                            ));
                        }
                        for each (var change_aa:Object in pObj.data.documentChanges) {
                            docChanges.push(ANEUtils.map(change_aa, DocumentChange) as DocumentChange);
                        }
                        querySnapshot.documents = docs;
                        querySnapshot.documentChanges = docChanges;
                        querySnapshot.metadata = ANEUtils.map(pObj.data.metadata, SnapshotMetadata) as SnapshotMetadata;
                    }

                    closure.call(null, querySnapshot, err);
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case BATCH_COMPLETE:
            case NETWORK_ENABLED:
            case NETWORK_DISABLED:
                pObj = JSON.parse(event.code);
                if (pObj.hasOwnProperty("error") && pObj.error) {
                    err = new FirestoreError(pObj.error.text, pObj.error.id);
                }
                closure = FirestoreANEContext.closures[pObj.eventId];
                if (closure) {
                    closure.call(null, err);
                    delete FirestoreANEContext.closures[pObj.eventId];
                }
                break;
            case DOCUMENT_DELETED:
            case DOCUMENT_UPDATED:
            case DOCUMENT_SET:
                try {
                    pObj = JSON.parse(event.code);
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new FirestoreError(pObj.error.text, pObj.error.id);
                    } else if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("path")) {
                        path = pObj.data.path;
                    }
                    closure = FirestoreANEContext.closures[pObj.eventId];
                    if (closure) {
                        closure.call(null, path, err);
                        delete FirestoreANEContext.closures[pObj.eventId];
                    }
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
