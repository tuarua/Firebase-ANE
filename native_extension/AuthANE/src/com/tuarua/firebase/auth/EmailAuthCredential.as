package com.tuarua.firebase.auth {
public class EmailAuthCredential extends AuthCredential {
    public function EmailAuthCredential(email:String, password:String) {
        super(Provider.EMAIL, email, password);
    }
}
}
