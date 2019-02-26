package com.tuarua.firebase.vision.text

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.text.FirebaseVisionText
import com.google.firebase.ml.vision.text.FirebaseVisionTextRecognizer
import com.google.gson.Gson
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.firebase.vision.text.events.TextEvent
import com.tuarua.firebase.vision.extensions.toFREObject
import com.tuarua.frekotlin.*
import java.util.*
import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private var results: MutableMap<String, FirebaseVisionText> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private lateinit var recognizer: FirebaseVisionTextRecognizer

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        recognizer = FirebaseVision.getInstance().onDeviceTextRecognizer
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
            recognizer.processImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    results[eventId] = task.result
                    dispatchEvent(TextEvent.RECOGNIZED,
                            gson.toJson(TextEvent(eventId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(TextEvent.RECOGNIZED,
                            gson.toJson(
                                    TextEvent(eventId, mapOf(
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
        val ret = results[eventId]?.toFREObject()
        results.remove(eventId)
        return ret
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        recognizer.close()
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
