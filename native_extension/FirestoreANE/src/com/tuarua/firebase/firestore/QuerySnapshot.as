package com.tuarua.firebase.firestore {
public class QuerySnapshot {
    public var documents:Vector.<DocumentSnapshot> = new <DocumentSnapshot>[];
    public var documentChanges:Vector.<DocumentChange> = new <DocumentChange>[];
    public var metadata:SnapshotMetadata;
    public function QuerySnapshot() {
    }

    public function get isEmpty():Boolean {
        return documents.length == 0;
    }

    public function get size():int {
        return documents.length;
    }
}
}
