package com.tuarua.firebase.auth

import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.*
import com.google.gson.Gson
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.firebase.auth.events.AuthErrorEvent
import com.tuarua.firebase.auth.events.AuthEvent


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

    fun createUserWithEmailAndPassword(email: String, password: String) {
        auth.createUserWithEmailAndPassword(email, password).addOnCompleteListener { task ->
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_CREATED, "")
                else -> {
                    //error.errorCode
                    //val error = task.exception as FirebaseAuthException
                    sendEvent(AuthErrorEvent.USER_CREATED_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
                }

            }
        }
    }


    fun signOut() {
        auth.signOut()
    }


    fun sendPasswordResetEmail(email: String) {
        auth.sendPasswordResetEmail(email).addOnCompleteListener { task ->
            trace("sendPasswordResetEmail", task.isSuccessful)
            when {
                task.isSuccessful -> sendEvent(AuthEvent.PASSWORD_RESET_EMAIL_SENT, "")
                else -> {
                    //error.errorCode
                    //val error = task.exception as FirebaseAuthException
                    sendEvent(AuthErrorEvent.PASSWORD_RESET_EMAIL_SENT_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
                }
            }
        }
    }

    fun deleteUser() {
        val user = auth.currentUser
        user?.delete()?.addOnCompleteListener { task ->
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_DELETED, "")
                else -> {
                    //error.errorCode
                    //val error = task.exception as FirebaseAuthException
                    sendEvent(AuthErrorEvent.USER_DELETED_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
                }
            }
        }
    }

    fun reauthenticate(email: String, password: String) {
        val credential = EmailAuthProvider.getCredential(email, password)
        val user = auth.currentUser
        user?.reauthenticate(credential)?.addOnCompleteListener { task ->
            trace("reauthenticate", task.isSuccessful)
            when {
                task.isSuccessful -> sendEvent(AuthEvent.USER_REAUTHENTICATED, "")
                else -> {
                    //error.errorCode
                    //val error = task.exception as FirebaseAuthException
                    sendEvent(AuthErrorEvent.USER_REAUTHENTICATED_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
                }
            }
        }
    }


    fun signInAnonymously() {
        auth.signInAnonymously().addOnCompleteListener { task ->
            when {
                task.isSuccessful -> sendEvent(AuthEvent.SIGN_IN, "")
                else -> {
                    //error.errorCode
                    //val error = task.exception as FirebaseAuthException
                    sendEvent(AuthErrorEvent.SIGNIN_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
                }
            }
        }
    }

    fun signInWithEmailAndPassword(email: String, password: String) {
        auth.signInWithEmailAndPassword(email, password).addOnCompleteListener { task ->
            when {
                task.isSuccessful -> sendEvent(AuthEvent.SIGN_IN, "")
                else -> when {
                    task.exception is FirebaseAuthInvalidUserException -> {
                        val error = task.exception as FirebaseAuthInvalidUserException
                        sendEvent(AuthErrorEvent.SIGNIN_ERROR, gson.toJson(AuthErrorEvent("", error.message, 0)))
                    }
                    task.exception is FirebaseAuthInvalidCredentialsException -> {
                        val error = task.exception as FirebaseAuthInvalidCredentialsException
                        sendEvent(AuthErrorEvent.SIGNIN_ERROR, gson.toJson(AuthErrorEvent("", error.message, 0)))
                    }
                    else -> {
                        sendEvent(AuthErrorEvent.SIGNIN_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
                        trace("unmatched exception")
                    }
                }
            }
            //ERROR_WRONG_PASSWORD
            //ERROR_USER_NOT_FOUND
            /*var errorCode = 0
                       when {
                           error.errorCode == "ERROR_WRONG_PASSWORD" -> errorCode = 1
                           error.errorCode == "ERROR_WRONG_U" -> errorCode = 2
                       }

                       sendEvent(AuthErrorEvent.EMAIL_SIGIN_ERROR, gson.toJson(AuthErrorEvent(error.message, errorCode)))*/
        }
    }

    fun setLanguageCode(code: String) = auth.setLanguageCode(code)
    val languageCode: String?
        get() {
            return auth.languageCode
        }

    override val TAG: String
        get() = this::class.java.simpleName


}
