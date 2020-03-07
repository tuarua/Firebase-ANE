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

data class AuthEvent(val callbackId: String, val data: Map<String, Any?>? = null, val error: Map<String, Any?>? = null) {
    companion object {
        const val EMAIL_UPDATED = "AuthEvent.EmailUpdated"
        const val PASSWORD_UPDATED = "AuthEvent.PasswordUpdated"
        const val PROFILE_UPDATED = "AuthEvent.ProfileUpdated"
        const val SIGN_IN = "AuthEvent.SignIn"
        const val ID_TOKEN = "AuthEvent.OnIdToken"
        const val PASSWORD_RESET_EMAIL_SENT = "AuthEvent.PasswordResetEmailSent"
        const val USER_DELETED = "AuthEvent.UserDeleted"
        const val USER_REAUTHENTICATED = "AuthEvent.UserReauthenticated"
        const val USER_CREATED = "AuthEvent.UserCreated"
        const val USER_UNLINKED = "AuthEvent.UserUnlinked"
        const val USER_LINKED = "AuthEvent.UserLinked"
        const val USER_RELOADED = "AuthEvent.UserReloaded"
        const val EMAIL_VERIFICATION_SENT = "AuthEvent.EmailVerificationSent"
        const val PHONE_CODE_SENT = "AuthEvent.PhoneCodeSent"
    }
}
