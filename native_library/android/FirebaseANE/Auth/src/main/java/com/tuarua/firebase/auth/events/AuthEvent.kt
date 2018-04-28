package com.tuarua.firebase.auth.events

class AuthEvent (val eventId: String, val data: Map<String, Any>? = null) {
    companion object {
        val SIGN_IN: String = "AuthEvent.SignIn"
        val PASSWORD_RESET_EMAIL_SENT: String = "AuthEvent.PasswordResetEmailSent"
        val USER_DELETED: String = "AuthEvent.UserDeleted"
        val USER_REAUTHENTICATED: String = "AuthEvent.UserReauthenticated"
        val USER_CREATED: String = "AuthEvent.UserCreated"
        val EMAIL_VERIFICATION_SENT: String = "AuthEvent.EmailVerificationSent"
    }
}
