package com.tuarua.firebase.vision.text

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.text.FirebaseVisionText
import com.google.gson.Gson
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.firebase.vision.text.events.TextEvent
import com.tuarua.firebase.vision.text.extensions.toFREObject
import com.tuarua.frekotlin.*
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private var results: MutableMap<String, MutableList<FirebaseVisionText.Block>> = mutableMapOf()
    private val gson = Gson()

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("detect")
        val image = FirebaseVisionImage(argv[0]) ?: return FreConversionException("image")
        val eventId = String(argv[1]) ?: return FreConversionException("eventId")
        val detector = FirebaseVision.getInstance().visionTextDetector
        detector.detectInImage(image).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                results[eventId] = task.result.blocks
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
        return null
    }

    fun getResults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getResults")
        val eventId = String(argv[0]) ?: return FreConversionException("eventId")
        val result = results[eventId] ?: return null
        try {
            val freArray = FREArray("com.tuarua.firebase.vision.TextBlock",
                    result.size, true)
            for (i in result.indices) {
                freArray[i] = result[i].toFREObject()
            }
            return freArray
        } catch (e: FreException) {
            trace(e.message)
            trace(e.stackTrace)
        }
        return null
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
