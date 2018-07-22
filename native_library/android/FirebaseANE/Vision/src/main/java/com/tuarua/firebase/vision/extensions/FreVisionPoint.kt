package com.tuarua.firebase.vision.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.common.FirebaseVisionPoint
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.FreException

fun FirebaseVisionPoint.toFREObject(): FREObject? {
    try {
        return FREObject("com.tuarua.firebase.vision.VisionPoint", x, y, z ?: 0)
    } catch (e: FreException) {
    }
    return null
}