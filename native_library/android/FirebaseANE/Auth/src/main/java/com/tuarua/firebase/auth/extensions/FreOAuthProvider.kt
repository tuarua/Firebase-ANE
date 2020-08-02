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
import com.google.firebase.auth.OAuthProvider
import com.tuarua.frekotlin.Map
import com.tuarua.frekotlin.get

fun OAuthProvider(freObject: FREObject?): OAuthProvider? {
    val rv = freObject ?: return null
    val providerId = com.tuarua.frekotlin.String(rv["providerId"]) ?: return null
    val scopes = com.tuarua.frekotlin.List<String>(rv["scopes"])
    val customParameters: Map<String, String>? = Map(rv["customParameters"])

    val builder = OAuthProvider.newBuilder(providerId)
    if (scopes.isNotEmpty()) {
        builder.scopes = scopes
    }

    if (customParameters?.isNotEmpty() == true) {
        builder.addCustomParameters(customParameters)
    }

    return builder.build()
}