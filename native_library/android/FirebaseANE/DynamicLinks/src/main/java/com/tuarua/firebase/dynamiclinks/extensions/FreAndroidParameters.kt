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
package com.tuarua.firebase.dynamiclinks.extensions

import android.net.Uri
import com.adobe.fre.FREObject
import com.google.firebase.dynamiclinks.DynamicLink
import com.google.firebase.dynamiclinks.DynamicLink.AndroidParameters.*
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun AndroidParameters(freObject: FREObject?): DynamicLink.AndroidParameters? {
    val rv = freObject ?: return null
    val packageName = String(rv["packageName"])
    val fallbackUrl = String(rv["fallbackUrl"])
    val minimumVersion = Int(rv["minimumVersion"])
    val builder: DynamicLink.AndroidParameters.Builder
    builder = when (packageName) {
        null -> Builder()
        else -> Builder(packageName)
    }
    if (fallbackUrl != null) builder.setFallbackUrl(Uri.parse(fallbackUrl))
    if (minimumVersion != null) builder.setMinimumVersion(minimumVersion)
    return builder.build()
}