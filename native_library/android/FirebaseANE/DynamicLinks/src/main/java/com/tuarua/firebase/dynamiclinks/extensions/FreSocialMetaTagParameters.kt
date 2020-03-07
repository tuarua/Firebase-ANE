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
import com.google.firebase.dynamiclinks.DynamicLink.*
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun SocialMetaTagParameters(freObject: FREObject?): SocialMetaTagParameters? {
    val rv = freObject ?: return null
    val description = String(rv["description"])
    val imageUrl = String(rv["imageUrl"])
    val title = String(rv["title"])
    val builder = SocialMetaTagParameters.Builder()
    if (description != null) builder.setDescription(description)
    if (imageUrl != null) builder.setImageUrl(Uri.parse(imageUrl))
    if (title != null) builder.setTitle(title)
    return builder.build()
}