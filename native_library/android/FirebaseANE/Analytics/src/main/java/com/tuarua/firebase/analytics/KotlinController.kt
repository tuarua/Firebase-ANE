package com.tuarua.firebase.analytics

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import android.os.Bundle

fun <V> Map<String, V>.toBundle(bundle: Bundle = Bundle()): Bundle = bundle.apply {
    forEach {
        val k = it.key
        val v = it.value
        when (v) {
            is String -> putString(k, v)
            is Int -> putInt(k, v)
            is Double -> putDouble(k, v)
            is Boolean -> putBoolean(k, v)
        }
    }
}

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var analyticsController: AnalyticsController

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        analyticsController = AnalyticsController(context)
        return true.toFREObject()
    }

    fun logEvent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("logEvent")
        val name = String(argv[0]) ?: return FreConversionException("name")
        val params: Map<String, Any> = Map(argv[1]) ?: return FreConversionException("params")
        val bundle = params.toBundle()
        analyticsController.logEvent(name, bundle)
        return null
    }

    fun setAnalyticsCollectionEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setAnalyticsCollectionEnabled")
        val enabled = Boolean(argv[0]) ?: return FreConversionException("enabled")
        analyticsController.setAnalyticsCollectionEnabled(enabled)
        return null
    }

    fun setCurrentScreen(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setCurrentScreen")
        val screenName = String(argv[0]) ?: return FreConversionException("screenName")
        analyticsController.setCurrentScreen(screenName)
        return null
    }

    fun setMinimumSessionDuration(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setMinimumSessionDuration")
        val milliseconds = Long(argv[0]) ?: return FreConversionException("milliseconds")
        analyticsController.setMinimumSessionDuration(milliseconds)
        return null
    }

    fun setSessionTimeoutDuration(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setSessionTimeoutDuration")
        val milliseconds = Long(argv[0]) ?: return FreConversionException("milliseconds")
        analyticsController.setSessionTimeoutDuration(milliseconds)
        return null
    }

    fun setUserId(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setUserId")
        val id = String(argv[0]) ?: return FreConversionException("id")
        analyticsController.setUserId(id)
        return null
    }

    fun setUserProperty(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("setUserProperty")
        val name = String(argv[0]) ?: return FreConversionException("name")
        val value = String(argv[1]) ?: return FreConversionException("value")
        analyticsController.setUserProperty(name, value)
        return null
    }

    fun resetAnalyticsData(ctx: FREContext, argv: FREArgv): FREObject? {
        analyticsController.resetAnalyticsData()
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