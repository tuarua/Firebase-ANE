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

fun Barcode.DriverLicense.toFREObject(): FREObject? {
    val ret = FREObject("com.tuarua.mlkit.vision.barcode.BarcodeDriverLicense")
    ret["addressCity"] = addressCity
    ret["addressState"] = addressState
    ret["addressStreet"] = addressStreet
    ret["addressZip"] = addressZip
    ret["birthDate"] = birthDate
    ret["documentType"] = documentType
    ret["expiryDate"] = expiryDate
    ret["firstName"] = firstName
    ret["gender"] = gender
    ret["issuingCountry"] = issuingCountry
    ret["issuingDate"] = issueDate
    ret["lastName"] = lastName
    ret["licenseNumber"] = licenseNumber
    ret["middleName"] = middleName
    return ret
}

operator fun FREObject?.set(name: String, value: Barcode.DriverLicense?) {
    val rv = this ?: return
    rv[name] = value?.toFREObject()
}