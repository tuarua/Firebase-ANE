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

import com.adobe.fre.FREObject
import com.google.firebase.ml.common.modeldownload.FirebaseLocalModel
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun FirebaseLocalModel(freObject: FREObject?): FirebaseLocalModel? {
    val rv = freObject ?: return null
    val name = String(rv["name"]) ?: return null
    val path = String(rv["path"]) ?: return null
    val builder = FirebaseLocalModel.Builder(name)
    builder.setAssetFilePath(path)
    return builder.build()
}