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

class AuthEvent(val eventId: String, val data: Map<String, Any?>? = null, val error: Map<String, Any?>? = null) {
    companion object {
        const val EMAIL_UPDATED: String = "AuthEvent.EmailUpdated"
        const val PASSWORD_UPDATED: String = "AuthEvent.PasswordUpdated"
        const val PROFILE_UPDATED: String = "AuthEvent.ProfileUpdated"
        const val SIGN_IN: String = "AuthEvent.SignIn"
        const val ID_TOKEN: String = "AuthEvent.OnIdToken"
        const val PASSWORD_RESET_EMAIL_SENT: String = "AuthEvent.PasswordResetEmailSent"
        const val USER_DELETED: String = "AuthEvent.UserDeleted"
        const val USER_REAUTHENTICATED: String = "AuthEvent.UserReauthenticated"
        const val USER_CREATED: String = "AuthEvent.UserCreated"
        const val USER_UNLINKED: String = "AuthEvent.UserUnlinked"
        const val USER_LINKED: String = "AuthEvent.UserLinked"
        const val USER_RELOADED: String = "AuthEvent.UserReloaded"
        const val EMAIL_VERIFICATION_SENT: String = "AuthEvent.EmailVerificationSent"
    }
}
