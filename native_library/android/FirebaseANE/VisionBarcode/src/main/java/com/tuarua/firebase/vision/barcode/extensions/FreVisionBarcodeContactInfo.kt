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

fun FirebaseVisionBarcode.ContactInfo.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.firebase.vision.BarcodeCalendarEvent")
    ret["jobTitle"] = this.title?.toFREObject()
    ret["name"] = this.name?.toFREObject()
    ret["organization"] = this.organization?.toFREObject()
    if (this.addresses.isNotEmpty()) {
        val freAddressArr = FREArray("com.tuarua.firebase.vision.BarcodeAddress",
                this.addresses.size, true) ?: return null
        for (i in this.addresses.indices) {
            freAddressArr[i] = this.addresses[i].toFREObject()
        }
        ret["addresses"] = freAddressArr
    }

    if (this.emails.isNotEmpty()) {
        val freEmailArr = FREArray("com.tuarua.firebase.vision.BarcodeEmail",
                this.emails.size, true) ?: return null
        for (i in this.emails.indices) {
            freEmailArr[i] = this.emails[i].toFREObject()
        }
        ret["emails"] = freEmailArr
    }

    if (this.phones.isNotEmpty()) {
        val frePhoneArr = FREArray("com.tuarua.firebase.vision.BarcodePhone",
                this.phones.size, true) ?: return null
        for (i in this.phones.indices) {
            frePhoneArr[i] = this.phones[i].toFREObject()
        }
        ret["phones"] = frePhoneArr
    }

    val urls = this.urls
    if (urls != null && urls.isNotEmpty()) {
        val freUrlArr = FREArray("String", urls.size, true) ?: return null
        for (i in urls.indices) {
            freUrlArr[i] = urls[i].toFREObject()
        }
        ret["urls"] = freUrlArr
    }
    return ret
}



