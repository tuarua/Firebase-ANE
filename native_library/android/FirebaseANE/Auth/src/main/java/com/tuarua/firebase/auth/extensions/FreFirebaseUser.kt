package com.tuarua.firebase.auth.extensions

import com.adobe.fre.FREObject
import com.google.firebase.auth.FirebaseUser
import com.tuarua.frekotlin.FREObject

fun FirebaseUser.toFREObject(): FREObject? {
    return FREObject("com.tuarua.firebase.auth.FirebaseUser",
            this.uid,
            this.displayName,
            this.email,
            this.isAnonymous,
            this.isEmailVerified,
            this.photoUrl.toString(),
            this.phoneNumber
    )
}