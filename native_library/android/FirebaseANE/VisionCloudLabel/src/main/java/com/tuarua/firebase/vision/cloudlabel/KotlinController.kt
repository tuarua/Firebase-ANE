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

package com.tuarua.firebase.vision.cloudlabel

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabel
import com.google.firebase.ml.vision.label.FirebaseVisionImageLabeler
import com.google.gson.Gson
import com.tuarua.firebase.vision.cloudlabel.events.CloudLabelEvent
import com.tuarua.firebase.vision.cloudlabel.extensions.FirebaseVisionCloudImageLabelerOptions
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.firebase.vision.extensions.toFREArray
import com.tuarua.frekotlin.*
import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private var results: MutableMap<String, MutableList<FirebaseVisionImageLabel>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private lateinit var detector: FirebaseVisionImageLabeler

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        val options = FirebaseVisionCloudImageLabelerOptions(argv[0])
        detector = if (options != null) {
            FirebaseVision.getInstance().getCloudImageLabeler(options)
        } else {
            FirebaseVision.getInstance().cloudImageLabeler
        }
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("detect")
        val image = FirebaseVisionImage(argv[0], ctx) ?: return null
        val eventId = String(argv[1]) ?: return null
        GlobalScope.launch(bgContext) {
            detector.processImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    results[eventId] = result
                    dispatchEvent(CloudLabelEvent.RECOGNIZED,
                            gson.toJson(CloudLabelEvent(eventId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(CloudLabelEvent.RECOGNIZED,
                            gson.toJson(
                                    CloudLabelEvent(eventId, mapOf(
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
        val eventId = String(argv[0]) ?: return null
        val result = results[eventId] ?: return null
        val ret = result.toFREArray()
        results.remove(eventId)
        return ret
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        detector.close()
        return null
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }

}