/*
 * Copyright 2021 Tua Rua Ltd.
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

package com.tuarua.google.googlesignin.extensions

import com.google.android.gms.auth.api.signin.GoogleSignInAccount

fun GoogleSignInAccount.toMap(): Map<String, Any?> {
    return mapOf(
            "id" to id,
            "idToken" to idToken,
            "serverAuthCode" to serverAuthCode,
            "email" to email,
            "photoUrl" to photoUrl?.toString(),
            "displayName" to displayName,
            "familyName" to familyName,
            "givenName" to givenName,
            "grantedScopes" to grantedScopes.toList().map { scope -> scope.scopeUri }
    )
}
