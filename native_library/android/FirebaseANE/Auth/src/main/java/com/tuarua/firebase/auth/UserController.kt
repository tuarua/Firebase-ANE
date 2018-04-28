package com.tuarua.firebase.auth

import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.gson.Gson
import com.tuarua.firebase.auth.events.AuthErrorEvent
import com.tuarua.firebase.auth.events.AuthEvent
import com.tuarua.frekotlin.FreKotlinController

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

    val currentUser: FirebaseUser?
        get() = auth.currentUser

    fun sendEmailVerification() {
        val user = auth.currentUser
        user?.sendEmailVerification()?.addOnCompleteListener { task ->
            trace("sendEmailVerification", task.isSuccessful)
            when {
                task.isSuccessful -> sendEvent(AuthEvent.EMAIL_VERIFICATION_SENT, "")
                else -> {
                    sendEvent(AuthErrorEvent.EMAIL_VERIFICATION_SENT_ERROR, gson.toJson(AuthErrorEvent("", task.exception?.message, 0)))
//                    sendEvent(Constants.ERROR, gson.toJson(AuthErrorEvent(AuthErrorCodes.EMAIL_VERIFICATION_ERROR,
//                            task.exception.toString())))
                }
            }
        }
    }

    fun updateEmail(email: String) {
        val user = auth.currentUser
        user?.updateEmail(email)?.addOnCompleteListener { task ->
            trace("updateEmail", task.isSuccessful)
        }
    }

    //TODO phone number

    fun updatePassword(password: String) {
        val user = auth.currentUser
        user?.updatePassword(password)?.addOnCompleteListener { task ->
            trace("updatePassword", task.isSuccessful)
        }
    }

    fun unlink(provider: String) {
        val user = auth.currentUser
        user?.unlink(provider)?.addOnCompleteListener { task ->
            trace("unlink", task.isSuccessful)
        }
    }

    private fun printUserDetails() {
        val user = auth.currentUser
        if (user != null) {
            trace("displayName", user.displayName)
            trace("isAnonymous", user.isAnonymous)
            trace("isEmailVerified", user.isEmailVerified)
            trace("photoUrl", user.photoUrl)
            trace("phoneNumber", user.phoneNumber)
            trace("email", user.email)
            trace("uid", user.uid)


            for (profile in user.providerData) {
                // Id of the provider (ex: google.com)
                trace("providerId", profile.providerId)
                trace("uid", profile.uid)

                trace("name", profile.displayName)
                trace("email", profile.email)
                trace("photoUrl", profile.photoUrl)

            }
            trace("-----------------------------")
        } else {
            trace("no user")
        }
    }


    override val TAG: String
        get() = this::class.java.simpleName


}