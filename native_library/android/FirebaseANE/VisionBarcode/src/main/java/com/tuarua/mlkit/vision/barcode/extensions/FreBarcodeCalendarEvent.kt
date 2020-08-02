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
package com.tuarua.mlkit.vision.barcode.extensions

import com.adobe.fre.FREObject
import com.google.mlkit.vision.barcode.Barcode
import com.tuarua.frekotlin.FREObject
import com.tuarua.frekotlin.set
import com.tuarua.frekotlin.toFREObject
import java.text.DateFormat

fun Barcode.CalendarEvent.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.mlkit.vision.barcode.BarcodeCalendarEvent")
    ret["end"] = end
    ret["eventDescription"] = description
    ret["location"] = location
    ret["organizer"] = organizer
    ret["start"] = start
    ret["status"] = status
    ret["summary"] = summary
    return ret
}

operator fun FREObject?.set(name: String, value: Barcode.CalendarEvent?) {
    val rv = this ?: return
    rv[name] = value?.toFREObject()
}

private fun Barcode.CalendarDateTime.toFREObject(): FREObject? {
    return DateFormat.getDateInstance().parse(this.rawValue).toFREObject()
}

operator fun FREObject?.set(name: String, value: Barcode.CalendarDateTime?) {
    val rv = this ?: return
    rv[name] = value?.toFREObject()
}
