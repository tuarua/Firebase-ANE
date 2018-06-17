package com.tuarua.firebase.auth {
public class AuthCredential {
    private var _provider:String;
    private var _param0:String;
    private var _param1:String;

    public function AuthCredential(provider:String, param0:String = null, param1:String = null) {
        this._provider = provider;
        this._param0 = param0;
        this._param1 = param1;
    }

    public function get provider():String {
        return _provider;
    }

    public function get param0():String {
        return _param0;
    }

    public function get param1():String {
        return _param1;
    }
}
}
