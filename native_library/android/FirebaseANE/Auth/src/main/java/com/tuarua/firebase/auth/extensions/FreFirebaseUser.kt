package com.tuarua.firebase.auth.extensions

import com.adobe.fre.FREObject
import com.google.firebase.auth.FirebaseUser
import com.tuarua.frekotlin.FREObject

fun FirebaseUser.toFREObject(): FREObject? {
    return FREObject("com.tuarua.firebase.auth.FirebaseUser",
            uid,
            displayName,
            email,
            isAnonymous,
            isEmailVerified,
            photoUrl.toString(),
            phoneNumber
    )
}

fun FirebaseUser.toMap(): Map<String, Any?>? {
    return mapOf(
            "uid" to uid,
            "displayName" to displayName,
            "email" to email,
            "isAnonymous" to isAnonymous,
            "isEmailVerified" to isEmailVerified,
            "photoUrl" to photoUrl.toString(),
            "phoneNumber" to phoneNumber
    )
}