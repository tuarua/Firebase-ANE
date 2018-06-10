package com.tuarua.firebase.auth {
public class FacebookAuthCredential extends AuthCredential {
    public function FacebookAuthCredential(accessToken:String) {
        super(Provider.FACEBOOK, accessToken);
    }
}
}
