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

import android.content.res.Resources
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.tuarua.frekotlin.*
import java.util.*
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.auth.api.signin.GoogleSignInClient

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private var googleSignInClient: GoogleSignInClient? = null
    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        val context = context ?: return FreException("no context").getError()
        val resources = context.activity?.resources
                ?: return FreException("no resources").getError()
        val act = context.activity ?: return FreException("no application context").getError()
        try {
            val apiKey = String(argv[0]) ?: resources.getString(context.getResourceId("string.default_web_client_id"))
            val gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                    .requestIdToken(apiKey)
                    .requestEmail()
                    .build()

            googleSignInClient = GoogleSignIn.getClient(act, gso)

        } catch (e: Resources.NotFoundException) {
            return FreException(
                    "Cannot find required default_web_client_id. Ensure Firebase resources file added to FirebaseANE"
            ).getError()
        }
        return true.toFREObject()
    }

    fun signIn(ctx: FREContext, argv: FREArgv): FREObject? {
        val signInIntent = googleSignInClient?.signInIntent ?: return null
        ctx.activity.startActivityForResult(signInIntent, ResultListener.RC_SIGN_IN)
        return null
    }

    fun signInSilently(ctx: FREContext, argv: FREArgv): FREObject? {
        googleSignInClient?.silentSignIn()
        return null
    }

    fun signOut(ctx: FREContext, argv: FREArgv): FREObject? {
        googleSignInClient?.signOut()
        return null
    }

    fun revokeAccess(ctx: FREContext, argv: FREArgv): FREObject? {
        googleSignInClient?.revokeAccess()
        return null
    }

    fun handle(ctx: FREContext, argv: FREArgv): FREObject? {
        return null
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }

}