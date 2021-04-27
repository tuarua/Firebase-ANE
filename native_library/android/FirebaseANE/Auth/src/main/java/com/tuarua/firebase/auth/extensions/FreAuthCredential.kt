/*
 * Copyright 2020 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@file:Suppress("FunctionName")

package com.tuarua.firebase.auth.extensions

import com.adobe.fre.FREObject
import com.google.firebase.auth.*
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

fun AuthCredential(freObject: FREObject?): AuthCredential? {
    val rv = freObject ?: return null
    val provider = String(rv["provider"])
    val param0 = String(rv["param0"]) ?: return null
    val param1 = String(rv["param1"])
    when (provider) {
        GoogleAuthProvider.PROVIDER_ID -> return GoogleAuthProvider.getCredential(param0, param1)
        TwitterAuthProvider.PROVIDER_ID -> when {
            param1 != null -> {
                return TwitterAuthProvider.getCredential(param0, param1)
            }
        }
        EmailAuthProvider.PROVIDER_ID -> when {
            param1 != null -> {
                return EmailAuthProvider.getCredential(param0, param1)
            }
        }
        GithubAuthProvider.PROVIDER_ID -> return GithubAuthProvider.getCredential(param0)
        FacebookAuthProvider.PROVIDER_ID -> return FacebookAuthProvider.getCredential(param0)
        PhoneAuthProvider.PROVIDER_ID -> when {
            param1 != null -> {
                return PhoneAuthProvider.getCredential(param0, param1)
            }
        }
        PlayGamesAuthProvider.PROVIDER_ID -> return PlayGamesAuthProvider.getCredential(param0)
        else -> {
            val builder = OAuthProvider.newCredentialBuilder(param0)
            return builder.build()
        }
    }
    return null
}