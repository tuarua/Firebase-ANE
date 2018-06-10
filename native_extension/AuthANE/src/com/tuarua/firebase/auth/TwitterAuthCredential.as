package com.tuarua.firebase.auth {
public class TwitterAuthCredential extends AuthCredential {
    public function TwitterAuthCredential(accessToken:String, secret:String) {
        super(Provider.TWITTER, accessToken, secret);
    }
}
}
