package com.tuarua.firebase.auth {
public class PhoneAuthCredential extends AuthCredential {
    public function PhoneAuthCredential(verificationId:String, code:String) {
        super(Provider.PHONE, verificationId, code);
    }
}
}
