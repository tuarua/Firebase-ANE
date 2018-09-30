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

package com.tuarua.firebase.vision.label

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.label.FirebaseVisionLabel
import com.google.firebase.ml.vision.label.FirebaseVisionLabelDetector
import com.google.gson.Gson
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.firebase.vision.label.events.LabelEvent
import com.tuarua.firebase.vision.label.extensions.FirebaseVisionLabelDetectorOptions
import com.tuarua.firebase.vision.label.extensions.toFREArray
import com.tuarua.frekotlin.*
import java.util.*
import kotlinx.coroutines.experimental.CommonPool
import kotlinx.coroutines.experimental.launch
import kotlin.coroutines.experimental.CoroutineContext

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private var results: MutableMap<String, MutableList<FirebaseVisionLabel>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = CommonPool
    private lateinit var detector: FirebaseVisionLabelDetector

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        val options = FirebaseVisionLabelDetectorOptions(argv[0])
        detector = if (options != null) {
            FirebaseVision.getInstance().getVisionLabelDetector(options)
        } else {
            FirebaseVision.getInstance().visionLabelDetector
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
        launch(bgContext) {
            detector.detectInImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    results[eventId] = task.result
                    dispatchEvent(LabelEvent.RECOGNIZED,
                            gson.toJson(LabelEvent(eventId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(LabelEvent.RECOGNIZED,
                            gson.toJson(
                                    LabelEvent(eventId, mapOf(
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