package com.tuarua.firebase.firestore {
public class FirestoreError extends Error {
    private var _stackTrace:String;
    private var _path:String;
    public function FirestoreError(path:String, message:String, stackTrace:String) {
        _stackTrace = stackTrace;
        _path = path;
        super(message, 0);
    }

    override public function getStackTrace():String {
        return _stackTrace;
    }

    public function get path():String {
        return _path;
    }
}
}
