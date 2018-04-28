package com.tuarua.firebase.auth.events

class AuthErrorEvent(val eventId: String, val text: String? = null, val id: Int = 0) {
    companion object {
        val SIGNIN_ERROR: String = "AuthErrorEvent.EmailSignInError"
        val USER_DELETED_ERROR: String = "AuthErrorEvent.UserDeletedError"
        val USER_REAUTHENTICATED_ERROR: String = "AuthErrorEvent.UserReauthenticatedError"
        val USER_CREATED_ERROR: String = "AuthErrorEvent.UserCreatedError"
        val PASSWORD_RESET_EMAIL_SENT_ERROR: String = "AuthErrorEvent.PasswordResetEmailSentError"
        val EMAIL_VERIFICATION_SENT_ERROR: String = "AuthErrorEvent.EmailVerificationSentError"
    }
}