/*
 *  Copyright 2021 Tua Rua Ltd.
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
package com.tuarua.google.googlesignin.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.api.Scope
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get
import com.tuarua.frekotlin.iterator

fun GoogleSignInOptions(freObject: FREObject?, defaultClientId: String?): GoogleSignInOptions {
    if (freObject == null) {
        return GoogleSignInOptions
                .Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestServerAuthCode(defaultClientId!!)
                .requestEmail()
                .build()
    }
    val builder = GoogleSignInOptions.Builder()
    val scopes = freObject["scopes"] as FREArray
    for (scope in scopes) {
        builder.requestScopes(Scope(String(scope)))
    }
    val serverClientId = String(freObject["serverClientId"])
    if (Boolean(freObject["requestIdToken"]) == true) {
        builder.requestIdToken(serverClientId ?: defaultClientId!!)
    }
    if (Boolean(freObject["requestServerAuthCode"]) == true) {
        builder.requestServerAuthCode(serverClientId ?: defaultClientId!!)
    }
    return builder.build()
}