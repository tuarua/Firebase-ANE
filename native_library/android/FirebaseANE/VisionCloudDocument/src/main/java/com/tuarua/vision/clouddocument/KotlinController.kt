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

package com.tuarua.vision.clouddocument

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.document.FirebaseVisionCloudDocumentRecognizerOptions
import com.google.firebase.ml.vision.document.FirebaseVisionDocumentText
import com.google.firebase.ml.vision.document.FirebaseVisionDocumentTextRecognizer
import com.google.gson.Gson
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.frekotlin.*
import com.tuarua.vision.clouddocument.events.CloudDocumentEvent
import com.tuarua.vision.clouddocument.extensions.FirebaseVisionCloudDocumentRecognizerOptions
import com.tuarua.vision.clouddocument.extensions.toFREObject
import kotlinx.coroutines.experimental.CommonPool
import kotlinx.coroutines.experimental.launch
import java.util.*
import kotlin.coroutines.experimental.CoroutineContext

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private var options: FirebaseVisionCloudDocumentRecognizerOptions? = null
    private var results: MutableMap<String, FirebaseVisionDocumentText> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = CommonPool

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        options = FirebaseVisionCloudDocumentRecognizerOptions(argv[0])
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("detect")
        val image = FirebaseVisionImage(argv[0], ctx) ?: return null
        val eventId = String(argv[1]) ?: return null
        val options = this.options

        launch(bgContext) {
            val detector: FirebaseVisionDocumentTextRecognizer = if (options != null) {
                FirebaseVision.getInstance().getCloudDocumentTextRecognizer(options)
            } else {
                FirebaseVision.getInstance().cloudDocumentTextRecognizer
            }

            detector.processImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    results[eventId] = task.result
                    dispatchEvent(CloudDocumentEvent.RECOGNIZED,
                            gson.toJson(CloudDocumentEvent(eventId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(CloudDocumentEvent.RECOGNIZED,
                            gson.toJson(
                                    CloudDocumentEvent(eventId, mapOf(
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
        return results[eventId]?.toFREObject()
    }

    fun getBlocks(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getBlocks")
        val resultId = String(argv[0]) ?: return null
        return results[resultId]?.blocks?.toFREObject(resultId)
    }

    fun getParagraphs(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("getParagraphs")
        val resultId = String(argv[0]) ?: return null
        val blockIndex = Int(argv[1]) ?: return null

        val document = results[resultId] ?: return null
        if (document.blocks.size <= blockIndex) return null
        return document.blocks[blockIndex].paragraphs.toFREObject(resultId, blockIndex)
    }

    fun getWords(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("getWords")
        val resultId = String(argv[0]) ?: return null
        val blockIndex = Int(argv[1]) ?: return null
        val paragraphIndex = Int(argv[2]) ?: return null

        val document = results[resultId] ?: return null
        if (document.blocks.size <= blockIndex) return null
        val block = document.blocks[blockIndex] ?: return null
        if (block.paragraphs.size <= paragraphIndex) return null
        val paragraph = block.paragraphs[paragraphIndex]
        return paragraph.words.toFREObject(resultId, blockIndex, paragraphIndex)
    }

    fun getSymbols(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException("getWords")
        val resultId = String(argv[0]) ?: return null
        val blockIndex = Int(argv[1]) ?: return null
        val paragraphIndex = Int(argv[2]) ?: return null
        val wordIndex = Int(argv[3]) ?: return null

        val document = results[resultId] ?: return null
        if (document.blocks.size <= blockIndex) return null
        val block = document.blocks[blockIndex] ?: return null
        if (block.paragraphs.size <= paragraphIndex) return null
        val paragraph = block.paragraphs[paragraphIndex] ?: return null
        if (paragraph.words.size <= wordIndex) return null
        return paragraph.words[wordIndex].symbols.toFREObject()
    }

    fun disposeResult(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("disposeResult")
        val id = String(argv[0]) ?: return null
        results.remove(id)
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