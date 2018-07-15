package com.tuarua.firebase.vision.face.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.common.FirebaseVisionPoint
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.toFREObject

fun FirebaseVisionPoint.toFREObject(): FREObject? {
    try {
        return FREObject("com.tuarua.firebase.vision.VisionPoint",
                x.toFREObject(), y.toFREObject(), z?.toFREObject() ?: 0.toFREObject())
    } catch (e: FreException) {
    }
    return null
}