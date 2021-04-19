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
package com.tuarua.google.googlesignin

import android.content.Intent
import com.adobe.air.FreKotlinActivityResultCallback
import com.adobe.fre.FREContext
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.common.api.ApiException
import com.google.gson.Gson
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.google.googlesignin.events.GoogleSignInEvent

class ResultListener(override var context: FREContext?) : FreKotlinController, FreKotlinActivityResultCallback {

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == RC_SIGN_IN) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            val completedTask = task ?: return
            try {
                val account = completedTask.getResult(ApiException::class.java) ?: return
                dispatchEvent(GoogleSignInEvent.SIGN_IN, Gson().toJson(GoogleSignInEvent(mapOf(
                        "id" to account.id,
                        "idToken" to account.idToken,
                        "serverAuthCode" to account.serverAuthCode,
                        "email" to account.email,
                        "photoUrl" to account.photoUrl,
                        "displayName" to account.displayName,
                        "familyName" to account.familyName,
                        "givenName" to account.givenName,
                        "grantedScopes" to account.grantedScopes.toList().map { scope -> scope.scopeUri }
                ))))
            } catch (e: ApiException) {
                dispatchEvent(GoogleSignInEvent.ERROR, Gson().toJson(GoogleSignInEvent(mapOf(
                        "id" to e.statusCode,
                        "text" to e.localizedMessage
                ))))
            }
        }
    }

    companion object {
        const val RC_SIGN_IN = 9001
    }

    override val TAG: String?
        get() = this::class.java.simpleName

}