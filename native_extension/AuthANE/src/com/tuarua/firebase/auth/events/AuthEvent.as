package com.tuarua.firebase.auth.events {
import flash.events.Event;

public class AuthEvent extends Event {
    public static const SIGN_IN:String = "AuthEvent.SignIn";
    public static const PASSWORD_RESET_EMAIL_SENT:String = "AuthEvent.PasswordResetEmailSent";
    public static const USER_DELETED:String = "AuthEvent.UserDeleted";
    public static const USER_REAUTHENTICATED:String = "AuthEvent.UserReauthenticated";
    public static const USER_CREATED:String = "AuthEvent.UserCreated";
    public static const EMAIL_VERIFICATION_SENT:String = "AuthEvent.EmailVerificationSent";

    public var data:*;

    public function AuthEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }

    public override function clone():Event {
        return new AuthEvent(type, this.data, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("AuthEvent", "data", "type", "bubbles", "cancelable");
    }
}
}
