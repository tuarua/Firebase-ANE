package com.tuarua.firebase {
import com.tuarua.firebase.firestore.DocumentChange;
import com.tuarua.firebase.firestore.DocumentReference;
import com.tuarua.firebase.firestore.DocumentSnapshot;
import com.tuarua.firebase.firestore.FirestoreError;
import com.tuarua.firebase.firestore.Query;
import com.tuarua.firebase.firestore.QuerySnapshot;
import com.tuarua.firebase.firestore.SnapshotMetadata;
import com.tuarua.firebase.firestore.WriteBatch;
import com.tuarua.firebase.firestore.events.BatchEvent;
import com.tuarua.firebase.firestore.events.DocumentEvent;
import com.tuarua.firebase.firestore.events.FirestoreErrorEvent;
import com.tuarua.firebase.firestore.events.QueryEvent;
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class FirestoreANEContext {
    internal static const NAME:String = "FirestoreANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;

    public static var listeners:Vector.<Object> = new <Object>[];
    public static var listenersObjects:Dictionary = new Dictionary();
    private static var listenersObject:* = null;
    private static var pObj:Object;

    public function FirestoreANEContext() {
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
            case DocumentEvent.SNAPSHOT:
                try {
                    pObj = JSON.parse(event.code);
                    var data_aa:Object = pObj.data.data;
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    if (listenersObject.mapTo) {
                        data_aa = ANEUtils.map(pObj.data.data, listenersObject.mapTo) as listenersObject.mapTo;
                    }
                    listenersObject.dispatchEvent(
                            new DocumentEvent(
                                    DocumentEvent.SNAPSHOT, new DocumentSnapshot(
                                            pObj.data.id,
                                            data_aa,
                                            pObj.data.exists,
                                            new SnapshotMetadata(
                                                    pObj.data.metadata.isFromCache, pObj.data.metadata.hasPendingWrites
                                            )
                                    ), pObj.realtime)
                    );

                } catch (e:Error) {
                    trace("DocumentEvent.SNAPSHOT parsing error", e.message, e.getStackTrace());
                }
                break;
            case QueryEvent.QUERY_SNAPSHOT:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    var querySnapshot:QuerySnapshot = new QuerySnapshot();
                    var docs:Vector.<DocumentSnapshot> = new <DocumentSnapshot>[];
                    var docChanges:Vector.<DocumentChange> = new <DocumentChange>[];
                    for each(var doc_ab:Object in pObj.data.documents) {
                        var data_ab:Object = doc_ab.data;
                        if (listenersObject.mapTo) {
                            data_ab = ANEUtils.map(doc_ab.data, listenersObject.mapTo) as listenersObject.mapTo;
                        }
                        docs.push(new DocumentSnapshot(
                                doc_ab.id,
                                data_ab,
                                doc_ab.exists,
                                new SnapshotMetadata(
                                        doc_ab.metadata.isFromCache,
                                        doc_ab.metadata.hasPendingWrites)
                                )
                        );
                    }
                    for each (var change_aa:Object in pObj.data.documentChanges) {
                        docChanges.push(
                                new DocumentChange(
                                        change_aa.newIndex,
                                        change_aa.oldIndex,
                                        change_aa.id,
                                        change_aa.type
                                )
                        )
                    }
                    querySnapshot.documents = docs;
                    querySnapshot.documentChanges = docChanges;
                    querySnapshot.metadata = new SnapshotMetadata(
                            pObj.data.metadata.isFromCache,
                            pObj.data.metadata.hasPendingWrites
                    );
                    listenersObject.dispatchEvent(new QueryEvent(QueryEvent.QUERY_SNAPSHOT, querySnapshot));
                } catch (e:Error) {
                    trace("QueryEvent.QUERY_SNAPSHOT parsing error", e.message, e.getStackTrace());
                }
                break;
            case DocumentEvent.COMPLETE:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    listenersObject.dispatchEvent(new DocumentEvent(event.level));
                } catch (e:Error) {
                    trace("DocumentEvent.COMPLETE parsing error", e.message, e.getStackTrace());
                }
                break;
            case BatchEvent.COMPLETE:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    listenersObject.dispatchEvent(new BatchEvent(event.level));
                } catch (e:Error) {
                    trace("BatchEvent.COMPLETE parsing error", e.message, e.getStackTrace());
                }
                break;
            case FirestoreErrorEvent.ERROR:
                try {
                    pObj = JSON.parse(event.code);
                    listenersObject = getListenerObject(event.level, pObj.eventId);
                    if (listenersObject == null) return;
                    listenersObject.dispatchEvent(new FirestoreErrorEvent(event.level, true, false, pObj.text, pObj.id));
                } catch (e:Error) {
                    trace("FirestoreErrorEvent.ERROR parsing error", event.code, e.message, e.getStackTrace());
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
    }
}
}
