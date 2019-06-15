/*
 * Copyright 2019 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.tuarua.firebase.ml.vision.common.extensions

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