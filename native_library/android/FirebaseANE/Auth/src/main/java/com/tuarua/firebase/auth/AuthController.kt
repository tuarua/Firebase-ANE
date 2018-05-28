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

import java.util.concurrent.TimeUnit;
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseNetworkException
import com.google.firebase.auth.*
import com.google.gson.Gson
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.firebase.auth.events.AuthEvent
import com.google.firebase.auth.AuthCredential
import com.google.firebase.auth.PhoneAuthProvider
import com.google.firebase.FirebaseException
import com.google.firebase.auth.PhoneAuthCredential

class AuthController(override var context: FREContext?) : FreKotlinController {
    private lateinit var auth: FirebaseAuth
    private val gson = Gson()


    init {
        val app = FirebaseApp.getInstance()
        if (app != null) {
            auth = FirebaseAuth.getInstance(app)


        } else {
            trace(">>>>>>>>>>NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
        }
    }

    private fun sendError(type: String, eventId: String, exception: Exception?) {
        when (exception) {
            is FirebaseNetworkException -> sendEvent(type, gson.toJson(
                    AuthEvent(eventId, error = mapOf(
                            "text" to exception.message,
                            "id" to 17020))))
            is FirebaseAuthException -> {
                trace(exception.errorCode)
                sendEvent(type, gson.toJson(
                        AuthEvent(eventId, error = exception.toMap()))
                )
            }
        }
    }

    fun createUserWithEmailAndPassword(email: String, password: String, eventId: String?) {
        auth.createUserWithEmailAndPassword(email, password).addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_CREATED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.USER_CREATED, eventId, task.exception)
            }
        }
    }

    fun signOut() {
        auth.signOut()
    }

    fun sendPasswordResetEmail(email: String, eventId: String?) {
        auth.sendPasswordResetEmail(email).addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.PASSWORD_RESET_EMAIL_SENT, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.PASSWORD_RESET_EMAIL_SENT, eventId, task.exception)
            }
        }
    }

    fun signInAnonymously(eventId: String?) {
        auth.signInAnonymously().addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.SIGN_IN, eventId, task.exception)
            }
        }
    }

    fun signInWithCustomToken(eventId: String?, token: String) {
        auth.signInWithCustomToken(token).addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.SIGN_IN, eventId, task.exception)
            }
        }
    }

    fun signIn(value: AuthCredential, eventId: String?) {
        auth.signInWithCredential(value).addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.SIGN_IN, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.SIGN_IN, eventId, task.exception)
            }
        }
    }

    fun verifyPhoneNumber(phoneNumber: String, eventId: String?) {
        val act = this.context?.activity ?: return
        val callbacks: PhoneAuthProvider.OnVerificationStateChangedCallbacks = object : PhoneAuthProvider

        .OnVerificationStateChangedCallbacks() {
            override fun onVerificationCompleted(credential: PhoneAuthCredential) {
                auth.signInWithCredential(credential)
            }

            override fun onVerificationFailed(e: FirebaseException) {
                if (eventId == null) return
                sendError(AuthEvent.PHONE_CODE_SENT, eventId, e)
            }

            override fun onCodeSent(verificationId: String?,
                                    token: PhoneAuthProvider.ForceResendingToken?) {
                if (eventId == null) return
                sendEvent(AuthEvent.PHONE_CODE_SENT, gson.toJson(AuthEvent(eventId,
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
