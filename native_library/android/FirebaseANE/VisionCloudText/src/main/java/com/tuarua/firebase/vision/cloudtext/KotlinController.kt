/*
 * Copyright 2018 Tua Rua Ltd.
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

package com.tuarua.firebase.vision.cloudtext

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.cloud.FirebaseVisionCloudDetectorOptions
import com.google.firebase.ml.vision.cloud.text.FirebaseVisionCloudText
import com.google.firebase.ml.vision.cloud.text.FirebaseVisionCloudTextDetector
import com.google.gson.Gson
import com.tuarua.firebase.vision.cloudtext.events.CloudTextEvent
import com.tuarua.firebase.vision.cloudtext.extensions.toFREObject
import com.tuarua.firebase.vision.extensions.FirebaseVisionCloudDetectorOptions
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.frekotlin.*

import java.util.*
import kotlin.coroutines.experimental.CoroutineContext
import kotlinx.coroutines.experimental.launch
import kotlinx.coroutines.experimental.CommonPool

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private var options: FirebaseVisionCloudDetectorOptions? = null
    private var results: MutableMap<String, FirebaseVisionCloudText> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = CommonPool

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        options = FirebaseVisionCloudDetectorOptions(argv[0])
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("detect")
        val image = FirebaseVisionImage(argv[0], ctx) ?: return FreConversionException("image")
        val eventId = String(argv[1]) ?: return FreConversionException("eventId")
        val options = this.options

        launch(bgContext) {
            val detector: FirebaseVisionCloudTextDetector = if (options != null) {
                FirebaseVision.getInstance().getVisionCloudTextDetector(options)
            } else {
                FirebaseVision.getInstance().visionCloudTextDetector
            }

            detector.detectInImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    results[eventId] = task.result
                    dispatchEvent(CloudTextEvent.RECOGNIZED,
                            gson.toJson(CloudTextEvent(eventId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(CloudTextEvent.RECOGNIZED,
                            gson.toJson(
                                    CloudTextEvent(eventId, mapOf(
                                            "text" to error?.message.toString(),
                                            "id" to 0))
                            )
                    )
                }
            }
        }

        return null
    }

    fun getResults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getResults")
        val eventId = String(argv[0]) ?: return FreConversionException("eventId")
        val result = results[eventId] ?: return null
        return result.toFREObject()
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
        }
}
