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

import java.util.concurrent.TimeUnit
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseNetworkException
import com.google.firebase.auth.*
import com.google.gson.Gson
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.firebase.auth.events.AuthEvent
import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.PhoneAuthProvider
import com.google.firebase.FirebaseException
import com.google.firebase.auth.PhoneAuthCredential
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase
import com.tuarua.firebase.auth.extensions.toMap

class AuthController(override var context: FREContext?) : FreKotlinController {
    private var auth: FirebaseAuth = Firebase.auth
    private val gson = Gson()

    private fun sendError(type: String, callbackId: String, exception: Exception?) {
        when (exception) {
            is FirebaseNetworkException -> dispatchEvent(type, gson.toJson(
                    AuthEvent(callbackId, error = mapOf(
                            "text" to exception.message,
                            "id" to 17020))))
            is FirebaseAuthException -> {
                dispatchEvent(type, gson.toJson(
                        AuthEvent(callbackId, error = exception.toMap()))
                )
            }
        }
    }

    fun createUserWithEmailAndPassword(email: String, password: String, callbackId: String?) {
        auth.createUserWithEmailAndPassword(email, password).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.USER_CREATED, gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.USER_CREATED, callbackId, task.exception)
            }
        }
    }

    fun signOut() {
        auth.signOut()
    }

    fun sendPasswordResetEmail(email: String, callbackId: String?) {
        auth.sendPasswordResetEmail(email).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.PASSWORD_RESET_EMAIL_SENT, gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.PASSWORD_RESET_EMAIL_SENT, callbackId, task.exception)
            }
        }
    }

    fun signInAnonymously(callbackId: String?) {
        auth.signInAnonymously().addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(callbackId, task.result?.toMap())))
                else -> sendError(AuthEvent.SIGN_IN, callbackId, task.exception)
            }
        }
    }

    fun signInWithCustomToken(callbackId: String?, token: String) {
        auth.signInWithCustomToken(token).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(callbackId, task.result?.toMap())))
                else -> sendError(AuthEvent.SIGN_IN, callbackId, task.exception)
            }
        }
    }

    fun signIn(value: AuthCredential, callbackId: String?) {
        auth.signInWithCredential(value).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(callbackId, task.result?.toMap())))
                else -> sendError(AuthEvent.SIGN_IN, callbackId, task.exception)
            }
        }
    }

    fun signIn(value: OAuthProvider, callbackId: String?) {
        val act = this.context?.activity ?: return
        auth.startActivityForSignInWithProvider(act, value).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> {
                    dispatchEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(callbackId, task.result?.toMap())))
                }
                else -> sendError(AuthEvent.SIGN_IN, callbackId, task.exception)
            }
        }
    }

    fun verifyPhoneNumber(phoneNumber: String, callbackId: String?) {
        val act = this.context?.activity ?: return
        val callbacks: PhoneAuthProvider.OnVerificationStateChangedCallbacks = object : PhoneAuthProvider

        .OnVerificationStateChangedCallbacks() {
            override fun onVerificationCompleted(credential: PhoneAuthCredential) {
                auth.signInWithCredential(credential)
            }

            override fun onVerificationFailed(e: FirebaseException) {
                if (callbackId == null) return
                sendError(AuthEvent.PHONE_CODE_SENT, callbackId, e)
            }

            override fun onCodeSent(verificationId: String, token: PhoneAuthProvider.ForceResendingToken) {
                super.onCodeSent(verificationId, token)
                if (callbackId == null) return
                dispatchEvent(AuthEvent.PHONE_CODE_SENT, gson.toJson(AuthEvent(callbackId,
                        mapOf("verificationId" to verificationId))))
            }
        }
        PhoneAuthProvider.getInstance().verifyPhoneNumber(phoneNumber, 60, TimeUnit.SECONDS, act, callbacks)
    }

    fun setLanguageCode(code: String) = auth.setLanguageCode(code)

    val languageCode: String?
        get() {
            return auth.languageCode
        }

    override val TAG: String
        get() = this::class.java.simpleName


}
