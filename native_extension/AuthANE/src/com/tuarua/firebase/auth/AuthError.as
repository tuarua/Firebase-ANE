package com.tuarua.firebase.auth {
public class AuthError extends Error {
    private var _stackTrace:String;
    public function AuthError(message:String, stackTrace:String) {
        _stackTrace = stackTrace;
        super(message, 0);
    }
    override public function getStackTrace():String {
        return _stackTrace;
    }
}
}
