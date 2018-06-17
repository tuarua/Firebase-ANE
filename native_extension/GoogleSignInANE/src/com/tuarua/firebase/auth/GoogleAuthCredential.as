package com.tuarua.firebase.auth {
public class GoogleAuthCredential extends AuthCredential {
    public function GoogleAuthCredential(idToken:String, accessToken:String) {
        super("google.com", idToken, accessToken);
    }
}
}
