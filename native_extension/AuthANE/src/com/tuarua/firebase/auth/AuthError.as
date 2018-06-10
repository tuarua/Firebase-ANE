package com.tuarua.firebase.auth {
public class AuthError extends Error {
    public function AuthError(message:* = "", id:* = 0) {
        super(message, id);
    }
}
}
