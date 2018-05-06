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

import android.net.Uri
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseNetworkException
import com.google.firebase.auth.*
import com.google.gson.Gson
import com.tuarua.firebase.auth.events.AuthErrorEvent
import com.tuarua.firebase.auth.events.AuthEvent
import com.tuarua.frekotlin.FreKotlinController
import java.net.URI

class UserController(override var context: FREContext?) : FreKotlinController {
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

    val currentUser: FirebaseUser?
        get() = auth.currentUser

    fun sendEmailVerification(eventId: String?) {
        val user = auth.currentUser
        user?.sendEmailVerification()?.addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.EMAIL_VERIFICATION_SENT, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.EMAIL_VERIFICATION_SENT, eventId, task.exception)
            }
        }
    }

    fun updateEmail(email: String, eventId: String?) {
        currentUser?.updateEmail(email)?.addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.EMAIL_UPDATED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.EMAIL_UPDATED, eventId, task.exception)
            }
        }
    }

    fun updatePassword(password: String, eventId: String?) {
        val user = auth.currentUser
        user?.updatePassword(password)?.addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.PASSWORD_UPDATED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.PASSWORD_UPDATED, eventId, task.exception)
            }
        }
    }

    fun deleteUser(eventId: String?) {
        currentUser?.delete()?.addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_DELETED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.USER_DELETED, eventId, task.exception)
            }
        }
    }

    fun reauthenticate(email: String, password: String, eventId: String?) {
        val credential = EmailAuthProvider.getCredential(email, password)
        currentUser?.reauthenticate(credential)?.addOnCompleteListener { task ->
            trace("reauthenticate", task.isSuccessful)
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_REAUTHENTICATED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.USER_REAUTHENTICATED, eventId, task.exception)
            }
        }
    }

    fun updateProfile(displayName: String?, photoUrl: String?, eventId: String?) {
        val request = UserProfileChangeRequest.Builder()
        when {
            displayName != null -> request.setDisplayName(displayName)
        }
        when {
            photoUrl != null -> request.setPhotoUri(Uri.parse(photoUrl))
        }
        currentUser?.updateProfile(request.build())?.addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.PROFILE_UPDATED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.PROFILE_UPDATED, eventId, task.exception)
            }
        }
    }

    fun reload() {
        currentUser?.reload()?.addOnCompleteListener { _ ->

        }
    }

    fun getIdToken(forceRefresh: Boolean, eventId: String) {
        currentUser?.getIdToken(forceRefresh)?.addOnCompleteListener { task ->
            sendEvent(AuthEvent.ID_TOKEN, gson.toJson(AuthEvent(eventId, mapOf("token" to task.result.token))))
        }
    }

    fun unlink(provider: String, eventId: String?) {
        currentUser?.unlink(provider)?.addOnCompleteListener { task ->
            if (eventId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_UNLINKED, gson.toJson(AuthEvent(eventId)))
                else -> sendError(AuthEvent.USER_UNLINKED, eventId, task.exception)
            }
        }
    }

    override val TAG: String
        get() = this::class.java.simpleName


}