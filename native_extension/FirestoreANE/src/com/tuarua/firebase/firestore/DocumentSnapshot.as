package com.tuarua.firebase.firestore {
public class DocumentSnapshot {
    public var id:String;
    public var data:*;
    public var exists:Boolean = false;
    public var metadata:SnapshotMetadata;

    public function DocumentSnapshot(id:String, data:*, exists:Boolean, metadata:SnapshotMetadata) {
        this.id = id;
        this.data = data;
        this.exists = exists;
        this.metadata = metadata;
    }

}
}
