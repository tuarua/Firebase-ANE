/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
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