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
package com.tuarua.firebase.ml.vision.barcode.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.tuarua.firebase.ml.vision.common.extensions.FREArray
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.set

fun FirebaseVisionBarcode.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.ml.vision.barcode.Barcode")
    ret["frame"] = boundingBox
    ret["rawValue"] = rawValue
    ret["displayValue"] = displayValue
    ret["format"] = format
    ret["cornerPoints"] = FREArray(cornerPoints)
    ret["valueType"] = valueType
    ret["email"] = email
    ret["phone"] = phone
    ret["sms"] = sms
    ret["url"] = url
    ret["wifi"] = wifi
    ret["geoPoint"] = geoPoint
    ret["contactInfo"] = contactInfo
    ret["driverLicense"] = driverLicense
    ret["calendarEvent"] = calendarEvent
    return ret
}

fun List<FirebaseVisionBarcode>.toFREObject(): FREArray? {
    return FREArray("com.tuarua.firebase.ml.vision.barcode.Barcode",
            size, true, this.map { it.toFREObject() })
}


