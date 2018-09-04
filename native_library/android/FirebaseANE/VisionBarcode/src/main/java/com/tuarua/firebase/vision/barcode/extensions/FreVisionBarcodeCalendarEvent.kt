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
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.set
import com.tuarua.frekotlin.toFREObject
import java.text.DateFormat

fun FirebaseVisionBarcode.CalendarEvent.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.vision.BarcodeCalendarEvent")
    ret["end"] = this.end?.toFREObject()
    ret["eventDescription"] = this.description?.toFREObject()
    ret["location"] = this.location?.toFREObject()
    ret["organizer"] = this.organizer?.toFREObject()
    ret["start"] = this.start?.toFREObject()
    ret["status"] = this.status?.toFREObject()
    ret["summary"] = this.summary?.toFREObject()

    return ret
}

private fun FirebaseVisionBarcode.CalendarDateTime.toFREObject(): FREObject? {
    return DateFormat.getDateInstance().parse(this.rawValue).toFREObject()
}
