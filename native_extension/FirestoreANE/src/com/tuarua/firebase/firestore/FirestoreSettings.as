package com.tuarua.firebase.firestore {
[RemoteClass(alias="com.tuarua.firebase.firestore.FirestoreSettings")]
public class FirestoreSettings {
    public var host:String;
    public var isPersistenceEnabled:Boolean = true;
    public var isSslEnabled:Boolean = true;
    public var areTimestampsInSnapshotsEnabled:Boolean = true;

    public function FirestoreSettings() {
    }
}
}
