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
@file:Suppress("FunctionName")

package com.tuarua.firebase.dynamiclinks.extensions

import android.net.Uri
import com.adobe.fre.FREObject
import com.google.firebase.dynamiclinks.DynamicLink
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

fun IosParameters(freObject: FREObject?): DynamicLink.IosParameters? {
    val rv = freObject ?: return null
    val bundleId = String(rv["bundleId"]) ?: return null
    val appStoreId = String(rv["appStoreId"])
    val customScheme = String(rv["customScheme"])
    val fallbackUrl = String(rv["fallbackUrl"])
    val ipadBundleId = String(rv["ipadBundleId"])
    val ipadFallbackUrl = String(rv["ipadFallbackUrl"])
    val minimumVersion = String(rv["minimumVersion"])

    val builder = DynamicLink.IosParameters.Builder(bundleId)
    if (appStoreId != null) builder.setAppStoreId(appStoreId)
    if (customScheme != null) builder.setCustomScheme(customScheme)
    if (fallbackUrl != null) builder.setFallbackUrl(Uri.parse(fallbackUrl))
    if (ipadBundleId != null) builder.setIpadBundleId(ipadBundleId)
    if (ipadFallbackUrl != null) builder.setIpadFallbackUrl(Uri.parse(ipadFallbackUrl))
    if (minimumVersion != null) builder.setMinimumVersion(minimumVersion)
    return builder.build()
}