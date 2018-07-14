package com.tuarua.firebase.vision.extensions

import com.adobe.fre.FREObject

import com.google.firebase.ml.vision.common.FirebaseVisionImage
import com.tuarua.frekotlin.display.Bitmap
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseVisionImage(freObject: FREObject?): FirebaseVisionImage? {
    val rv = freObject ?: return null
    val bitmap = Bitmap(rv["bitmapdata"]) ?: return null
    return FirebaseVisionImage.fromBitmap(bitmap)
}