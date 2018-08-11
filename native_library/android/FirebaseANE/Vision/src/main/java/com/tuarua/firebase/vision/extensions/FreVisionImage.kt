package com.tuarua.firebase.vision.extensions

import android.net.Uri
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject

import com.google.firebase.ml.vision.common.FirebaseVisionImage
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.display.Bitmap
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseVisionImage(freObject: FREObject?, ctx: FREContext): FirebaseVisionImage? {
    val rv = freObject ?: return null
    val bitmap = Bitmap(rv["bitmapdata"])
    val path = String(rv["path"])
    return when {
        bitmap != null -> FirebaseVisionImage.fromBitmap(bitmap)
        path != null -> FirebaseVisionImage.fromFilePath(ctx.activity.applicationContext, Uri.parse(path))
        else -> null
    }

}