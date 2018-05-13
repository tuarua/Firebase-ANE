package com.tuarua.firebase.auth {
public class GithubAuthCredential extends AuthCredential {
    public function GithubAuthCredential(accessToken:String) {
        super(Provider.GITHUB, accessToken);
    }
}
}
