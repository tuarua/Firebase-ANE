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

package com.tuarua.firebase.ml.vision.document

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.document.FirebaseVisionDocumentText
import com.google.firebase.ml.vision.document.FirebaseVisionDocumentTextRecognizer
import com.google.gson.Gson
import com.tuarua.firebase.ml.vision.common.extensions.FirebaseVisionImage
import com.tuarua.firebase.ml.vision.document.events.CloudDocumentEvent
import com.tuarua.frekotlin.*
import com.tuarua.firebase.ml.vision.document.extensions.FirebaseVisionCloudDocumentRecognizerOptions
import com.tuarua.firebase.ml.vision.document.extensions.toFREObject
import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController {
    private var results: MutableMap<String, FirebaseVisionDocumentText> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private lateinit var recognizer: FirebaseVisionDocumentTextRecognizer

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val options = FirebaseVisionCloudDocumentRecognizerOptions(argv[0])
        recognizer = if (options != null) {
            FirebaseVision.getInstance().getCloudDocumentTextRecognizer(options)
        } else {
            FirebaseVision.getInstance().cloudDocumentTextRecognizer
        }
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun process(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val image = FirebaseVisionImage(argv[0], ctx) ?: return null
        val callbackId = String(argv[1]) ?: return null
        GlobalScope.launch(bgContext) {
            recognizer.processImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    results[callbackId] = result
                    dispatchEvent(CloudDocumentEvent.RECOGNIZED,
                            gson.toJson(CloudDocumentEvent(callbackId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(CloudDocumentEvent.RECOGNIZED,
                            gson.toJson(
                                    CloudDocumentEvent(callbackId, mapOf(
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
        val callbackId = String(argv[0]) ?: return null
        return results[callbackId]?.toFREObject(callbackId)
    }

    fun getBlocks(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        return results[id]?.blocks?.toFREObject(id)
    }

    fun getParagraphs(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val blockIndex = Int(argv[1]) ?: return null

        val document = results[id] ?: return null
        if (document.blocks.size <= blockIndex) return null
        return document.blocks[blockIndex].paragraphs.toFREObject(id, blockIndex)
    }

    fun getWords(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val blockIndex = Int(argv[1]) ?: return null
        val paragraphIndex = Int(argv[2]) ?: return null

        val document = results[id] ?: return null
        if (document.blocks.size <= blockIndex) return null
        val block = document.blocks[blockIndex] ?: return null
        if (block.paragraphs.size <= paragraphIndex) return null
        val paragraph = block.paragraphs[paragraphIndex]
        return paragraph.words.toFREObject(id, blockIndex, paragraphIndex)
    }

    fun getSymbols(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        val blockIndex = Int(argv[1]) ?: return null
        val paragraphIndex = Int(argv[2]) ?: return null
        val wordIndex = Int(argv[3]) ?: return null

        val document = results[id] ?: return null
        if (document.blocks.size <= blockIndex) return null
        val block = document.blocks[blockIndex] ?: return null
        if (block.paragraphs.size <= paragraphIndex) return null
        val paragraph = block.paragraphs[paragraphIndex] ?: return null
        if (paragraph.words.size <= wordIndex) return null
        return paragraph.words[wordIndex].symbols.toFREObject()
    }

    fun disposeResult(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        results.remove(id)
        return null
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        recognizer.close()
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