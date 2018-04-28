package com.tuarua.firebase.firestore {
public class DocumentChange {
    public var newIndex:int;
    public var oldIndex:int;
    public var documentId:String;
    public var type:int;

    public function DocumentChange(newIndex:int, oldIndex:int, documentId:String, type:int) {
        this.newIndex = newIndex;
        this.oldIndex = oldIndex;
        this.type = type;
        this.documentId = documentId;
    }
}
}
