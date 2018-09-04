/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.firebase.vision.barcode.extensions

import com.adobe.fre.FREArray
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.tuarua.firebase.vision.extensions.FREArray
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.toFREObject

fun FirebaseVisionBarcode.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.vision.Barcode")
    ret["frame"] = this.boundingBox?.toFREObject()
    ret["rawValue"] = this.rawValue?.toFREObject()
    ret["displayValue"] = this.displayValue?.toFREObject()
    ret["format"] = this.format.toFREObject()
    ret["cornerPoints"] = FREArray(this.cornerPoints)
    ret["valueType"] = this.valueType.toFREObject()
    ret["email"] = this.email?.toFREObject()
    ret["phone"] = this.phone?.toFREObject()
    ret["sms"] = this.sms?.toFREObject()
    ret["url"] = this.url?.toFREObject()
    ret["wifi"] = this.wifi?.toFREObject()
    ret["geoPoint"] = this.geoPoint?.toFREObject()
    ret["contactInfo"] = this.contactInfo?.toFREObject()
    ret["driverLicense"] = this.driverLicense?.toFREObject()
    ret["calendarEvent"] = this.calendarEvent?.toFREObject()
    return ret
}

fun List<FirebaseVisionBarcode>.toFREArray(): FREArray? {
    val ret = FREArray("com.tuarua.firebase.vision.Barcode", size, true)
            ?: return null
    for (i in this.indices) {
        ret[i] = this[i].toFREObject()
    }
    return ret
}


