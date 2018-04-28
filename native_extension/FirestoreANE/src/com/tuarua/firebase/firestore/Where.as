package com.tuarua.firebase.firestore {
[RemoteClass(alias="com.tuarua.firebase.firestore.Where")]
public class Where {
    private var _fieldPath:String;
    private var _operator:String;
    private var _value:*;

    public function Where(fieldPath:String, operator:String, value:*) {
        this._fieldPath = fieldPath;
        this._operator = operator;
        this._value = value;
    }

    public function get fieldPath():String {
        return _fieldPath;
    }

    public function get operator():String {
        return _operator;
    }

    public function get value():* {
        return _value;
    }
}
}
