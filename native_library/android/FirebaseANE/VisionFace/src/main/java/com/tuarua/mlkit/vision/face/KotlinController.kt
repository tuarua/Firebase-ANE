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
package com.tuarua.mlkit.vision.face

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.gson.Gson
import com.google.mlkit.vision.face.Face
import com.google.mlkit.vision.face.FaceDetection
import com.google.mlkit.vision.face.FaceDetector
import com.tuarua.mlkit.vision.face.events.FaceEvent
import com.tuarua.mlkit.vision.face.extensions.FaceDetectorOptions
import com.tuarua.mlkit.vision.face.extensions.toFREObject
import com.tuarua.frekotlin.*
import com.tuarua.mlkit.vision.extensions.InputImage
import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController {
    private var results: MutableMap<String, MutableList<Face>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private lateinit var detector: FaceDetector
    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val options = FaceDetectorOptions(argv[0])

        detector = if (options != null) {
            FaceDetection.getClient(options)
        } else {
            FaceDetection.getClient()
        }
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val image = InputImage(argv[0], ctx) ?: return null
        val callbackId = String(argv[1]) ?: return null

        GlobalScope.launch(bgContext) {
            detector.process(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    if (result.isNotEmpty()) {
                        results[callbackId] = result
                        dispatchEvent(FaceEvent.DETECTED,
                                gson.toJson(FaceEvent(callbackId, null)))
                    }
                } else {
                    val error = task.exception
                    dispatchEvent(FaceEvent.DETECTED,
                            gson.toJson(
                                    FaceEvent(callbackId, mapOf(
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
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val result = results[id] ?: return null
        val ret = result.toFREObject()
        results.remove(id)
        return ret
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        detector.close()
        return null
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }

}

