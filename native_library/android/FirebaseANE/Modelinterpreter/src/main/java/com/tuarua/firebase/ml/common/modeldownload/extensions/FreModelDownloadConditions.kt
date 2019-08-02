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

package com.tuarua.firebase.ml.common.modeldownload.extensions

import android.os.Build
import com.adobe.fre.FREObject
import com.google.firebase.ml.common.modeldownload.FirebaseModelDownloadConditions
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseModelDownloadConditions(freObject: FREObject?): FirebaseModelDownloadConditions? {
    val rv = freObject ?: return null
    val isWiFiRequired = Boolean(rv["isWiFiRequired"]) ?: false
    val isChargingRequired = Boolean(rv["isChargingRequired"]) ?: false
    val isDeviceIdleRequired = Boolean(rv["isDeviceIdleRequired"]) ?: false
    val builder = FirebaseModelDownloadConditions.Builder()
    if (isWiFiRequired) {
        builder.requireWifi()
    }
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
        if (isChargingRequired) {
            builder.requireCharging()
        }
        if (isDeviceIdleRequired) {
            builder.requireDeviceIdle()
        }

    }
    return builder.build()
}