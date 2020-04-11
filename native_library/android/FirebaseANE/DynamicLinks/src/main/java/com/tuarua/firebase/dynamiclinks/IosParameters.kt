/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.firebase.dynamiclinks

import com.adobe.fre.FREObject
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

class IosParameters(freObject: FREObject?) {
    val appStoreId = String(freObject["appStoreId"])
    val bundleId = String(freObject["bundleId"]) ?: ""
    val customScheme = String(freObject["customScheme"])
    val fallbackUrl = String(freObject["fallbackUrl"])
    val ipadBundleId = String(freObject["ipadBundleId"])
    val ipadFallbackUrl = String(freObject["ipadFallbackUrl"])
    val minimumVersion = String(freObject["minimumVersion"])
}