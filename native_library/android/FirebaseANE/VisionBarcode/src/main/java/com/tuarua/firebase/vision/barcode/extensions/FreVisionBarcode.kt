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

import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.tuarua.frekotlin.*
import com.tuarua.frekotlin.geom.Rect
import com.tuarua.frekotlin.geom.toFREObject
import com.tuarua.frekotlin.geom.Point

fun FirebaseVisionBarcode.toFREObject(): FREObject? {
    try {
        val ret = FREObject("com.tuarua.firebase.vision.Barcode")
        val freCornerPoints = FREArray("flash.geom.Point",
                this.cornerPoints?.size ?: 0, true)

        ret["frame"] = Rect(this.boundingBox?.left ?: 0,
                this.boundingBox?.bottom ?: 0,
                this.boundingBox?.width() ?: 0,
                this.boundingBox?.height() ?: 0).toFREObject()

        ret["rawValue"] = this.rawValue?.toFREObject()
        ret["displayValue"] = this.displayValue?.toFREObject()
        ret["format"] = this.format.toFREObject()

        val cornerPoints = this.cornerPoints
        if (cornerPoints != null && !cornerPoints.isEmpty()) {
            for (i in cornerPoints.indices) {
                val p = cornerPoints[0]
                freCornerPoints[i] = Point(p.x, p.y).toFREObject()
            }
        }

        ret["cornerPoints"] = freCornerPoints
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
    } catch (e: FreException) {
    }

    return null
}




