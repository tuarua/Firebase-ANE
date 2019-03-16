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

package com.tuarua.firebase.modelinterpreter.extensions

import com.adobe.fre.FREObject
import com.google.firebase.ml.custom.FirebaseModelInputs
import com.google.firebase.ml.custom.FirebaseModelInputs.Builder
import com.tuarua.frekotlin.FreByteArrayKotlin
import com.tuarua.frekotlin.get
import java.nio.ByteOrder

@Suppress("FunctionName")
fun FirebaseModelInputs(freObject: FREObject?): FirebaseModelInputs? {
    val rv = freObject ?: return null
    val freInputs = rv["input"] ?: return null
    val builder = Builder()
    val asByteArray = FreByteArrayKotlin(freInputs)
    asByteArray.acquire()
    val byteData = asByteArray.bytes
    if (byteData != null) {
        builder.add(byteData.order(ByteOrder.nativeOrder()))
    }
    asByteArray.release()
    return builder.build()
}