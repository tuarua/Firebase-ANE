@file:Suppress("FunctionName")

package com.tuarua.firebase.auth.extensions

import com.adobe.fre.FREObject
import com.google.firebase.auth.*
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

fun AuthCredential(freObject: FREObject?): AuthCredential? {
    val rv = freObject ?: return null
    val provider = String(rv["provider"])
    val param0 = String(rv["param0"])
    val param1 = String(rv["param1"])
    when (provider) {
        GoogleAuthProvider.PROVIDER_ID -> return GoogleAuthProvider.getCredential(param0, param1)
        TwitterAuthProvider.PROVIDER_ID -> when {
            param0 != null && param1 != null -> {
                return TwitterAuthProvider.getCredential(param0, param1)
            }
        }
        EmailAuthProvider.PROVIDER_ID -> when {
            param0 != null && param1 != null -> {
                return EmailAuthProvider.getCredential(param0, param1)
            }
        }
        GithubAuthProvider.PROVIDER_ID -> when {
            param0 != null -> return GithubAuthProvider.getCredential(param0)
        }
        FacebookAuthProvider.PROVIDER_ID -> when {
            param0 != null -> return FacebookAuthProvider.getCredential(param0)
        }
        PhoneAuthProvider.PROVIDER_ID -> when {
            param0 != null && param1 != null -> {
                return PhoneAuthProvider.getCredential(param0, param1)
            }
        }
    }
    return null
}