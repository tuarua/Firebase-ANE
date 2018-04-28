package com.tuarua.firebase.auth.events {
import flash.events.ErrorEvent;

public class AuthErrorEvent extends ErrorEvent {
    public static const SIGN_IN_ERROR:String = "AuthErrorEvent.SignInError";
    public static const SIGN_OUT_ERROR:String = "AuthErrorEvent.SignOutError";
    public static const USER_DELETED_ERROR:String = "AuthErrorEvent.UserDeletedError";
    public static const USER_REAUTHENTICATED_ERROR:String = "AuthErrorEvent.UserReauthenticatedError";
    public static const USER_CREATED_ERROR:String = "AuthErrorEvent.UserCreatedError";
    public static const PASSWORD_RESET_EMAIL_SENT_ERROR:String = "AuthErrorEvent.PasswordResetEmailSentError";
    public static const EMAIL_VERIFICATION_SENT_ERROR:String = "AuthErrorEvent.EmailVerificationSentError";

    public function AuthErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0) {
        super(type, bubbles, cancelable, text, id);
    }
}
}
