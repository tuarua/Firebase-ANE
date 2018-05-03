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
package com.tuarua.firebase.auth

import com.adobe.fre.FREObject
import com.google.firebase.auth.FirebaseAuthException
import com.google.firebase.auth.FirebaseUser
import com.tuarua.frekotlin.FREObject

fun FirebaseUser.toFREObject(): FREObject? {
    return FREObject("com.tuarua.firebase.auth.FirebaseUser",
            this.uid,
            this.displayName,
            this.email,
            this.isAnonymous,
            this.isEmailVerified,
            this.photoUrl.toString(),
            this.phoneNumber
    )
}

val FirebaseAuthExceptionMap: Map<String, Int>
    get() = mapOf(
            "ERROR_WRONG_PASSWORD" to 17009,
            "ERROR_USER_NOT_FOUND" to 17011,
            "ERROR_USER_DISABLED" to 17005,
            "ERROR_INVALID_EMAIL" to 17008,
            "ERROR_EMAIL_ALREADY_IN_USE" to 17007,
            "ERROR_WEAK_PASSWORD" to 17026
)

fun FirebaseAuthException.toMap(): Map<String, Any?>? {
    return mapOf(
            "text" to this.message.toString(),
            "id" to FirebaseAuthExceptionMap[this.errorCode])
}