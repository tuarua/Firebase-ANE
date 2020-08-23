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
import com.tuarua.frekotlin.*

fun Barcode.ContactInfo.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.mlkit.vision.barcode.BarcodeContactInfo")
    ret["jobTitle"] = title
    ret["name"] = name
    ret["organization"] = organization

    if (addresses.isNotEmpty()) {
        val freAddressArr = FREArray("com.tuarua.mlkit.vision.barcode.BarcodeAddress",
                addresses.size, true, addresses.map { it.toFREObject() }) ?: return null
        ret["addresses"] = freAddressArr
    }

    if (emails.isNotEmpty()) {
        val freEmailArr = FREArray("com.tuarua.mlkit.vision.barcode.BarcodeEmail",
                emails.size, true, emails.map { it.toFREObject() }) ?: return null
        ret["emails"] = freEmailArr
    }

    if (phones.isNotEmpty()) {
        val frePhoneArr = FREArray("com.tuarua.mlkit.vision.barcode.BarcodePhone",
                phones.size, true, phones.map { it.toFREObject() }) ?: return null
        ret["phones"] = frePhoneArr
    }

    val urls = this.urls
    if (urls.isNotEmpty()) {
        val freUrlArr = FREArray("String", urls.size, true,
                urls.map { it.toFREObject() }) ?: return null
        ret["urls"] = freUrlArr
    }
    return ret
}

operator fun FREObject?.set(name: String, value: Barcode.ContactInfo?) {
    val rv = this ?: return
    rv[name] = value?.toFREObject()
}


