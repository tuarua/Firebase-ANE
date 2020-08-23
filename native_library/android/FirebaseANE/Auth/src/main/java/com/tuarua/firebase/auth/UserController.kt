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
import com.google.firebase.FirebaseException
import com.google.firebase.FirebaseNetworkException
import com.google.firebase.auth.*
import com.google.firebase.ktx.Firebase
import com.google.firebase.ktx.app
import com.google.gson.Gson
import com.tuarua.firebase.auth.events.AuthEvent
import com.tuarua.firebase.auth.extensions.toMap
import com.tuarua.frekotlin.FreKotlinController

class UserController(override var context: FREContext?) : FreKotlinController {
    private var auth: FirebaseAuth = FirebaseAuth.getInstance(Firebase.app)
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
            is FirebaseException -> {
                dispatchEvent(type, gson.toJson(
                        AuthEvent(callbackId, error = exception.toMap()))
                )
            }
        }
    }

    val currentUser: FirebaseUser?
        get() = auth.currentUser

    fun sendEmailVerification(callbackId: String?) {
        val user = auth.currentUser
        user?.sendEmailVerification()?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.EMAIL_VERIFICATION_SENT,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.EMAIL_VERIFICATION_SENT, callbackId, task.exception)
            }
        }
    }

    fun updateEmail(email: String, callbackId: String?) {
        currentUser?.updateEmail(email)?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.EMAIL_UPDATED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.EMAIL_UPDATED, callbackId, task.exception)
            }
        }
    }

    fun updatePassword(password: String, callbackId: String?) {
        val user = auth.currentUser
        user?.updatePassword(password)?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.PASSWORD_UPDATED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.PASSWORD_UPDATED, callbackId, task.exception)
            }
        }
    }

    fun deleteUser(callbackId: String?) {
        currentUser?.delete()?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.USER_DELETED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.USER_DELETED, callbackId, task.exception)
            }
        }
    }

    fun reauthenticate(credential: AuthCredential, callbackId: String?) {
        currentUser?.reauthenticate(credential)?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.USER_REAUTHENTICATED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.USER_REAUTHENTICATED, callbackId, task.exception)
            }
        }
    }

    fun reauthenticate(provider: OAuthProvider, callbackId: String?) {
        val act = this.context?.activity ?: return
        currentUser?.startActivityForReauthenticateWithProvider(act, provider)?.addOnCompleteListener {task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.USER_REAUTHENTICATED, gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.USER_REAUTHENTICATED, callbackId, task.exception)
            }
        }
    }

    fun updateProfile(displayName: String?, photoUrl: String?, callbackId: String?) {
        val request = UserProfileChangeRequest.Builder()
        when {
            displayName != null -> request.displayName = displayName
        }
        when {
            photoUrl != null -> request.photoUri = Uri.parse(photoUrl)
        }
        currentUser?.updateProfile(request.build())?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.PROFILE_UPDATED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.PROFILE_UPDATED, callbackId, task.exception)
            }
        }
    }

    fun reload(callbackId: String?) {
        currentUser?.reload()?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.USER_RELOADED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.USER_RELOADED, callbackId, task.exception)
            }
        }
    }

    fun getIdToken(forceRefresh: Boolean, callbackId: String) {
        currentUser?.getIdToken(forceRefresh)?.addOnCompleteListener { task ->
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.ID_TOKEN,
                        gson.toJson(AuthEvent(callbackId, mapOf("token" to task.result?.token))))
                else -> sendError(AuthEvent.ID_TOKEN, callbackId, task.exception)
            }
        }
    }

    fun unlink(provider: String, callbackId: String?) {
        currentUser?.unlink(provider)?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> dispatchEvent(AuthEvent.USER_UNLINKED,
                        gson.toJson(AuthEvent(callbackId)))
                else -> sendError(AuthEvent.USER_UNLINKED, callbackId, task.exception)
            }
        }
    }

    fun link(value: AuthCredential, callbackId: String?) {
        currentUser?.linkWithCredential(value)?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            when {
                task.isSuccessful -> {
                    dispatchEvent(AuthEvent.USER_LINKED,
                            gson.toJson(AuthEvent(callbackId)))
                }
                else -> sendError(AuthEvent.USER_LINKED, callbackId, task.exception)
            }
        }
    }

    override val TAG: String?
        get() = this::class.java.simpleName
}