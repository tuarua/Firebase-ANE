package com.tuarua.firebase.analytics

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import android.os.Bundle
import android.util.Log
import com.google.firebase.analytics.FirebaseAnalytics

fun <V> Map<String, V>.toBundle(bundle: Bundle = Bundle()): Bundle = bundle.apply {
    forEach {
        val k = it.key
        when (val v = it.value) {
            is String -> putString(k, v)
            is Int -> putInt(k, v)
            is Double -> putDouble(k, v)
            is Boolean -> putBoolean(k, v)
        }
    }
}

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private lateinit var analytics: FirebaseAnalytics
    private var appInstanceId: String? = null
    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            val ac = context?.activity
            if (ac != null) {
                analytics = FirebaseAnalytics.getInstance(ac)
                analytics.appInstanceId.addOnCompleteListener {
                    appInstanceId = it.result
                }
            } else {
                trace("Firebase is NOT initialised")
                return false.toFREObject()
            }
        } catch (e: Exception) {
            trace(e.message)
            trace(Log.getStackTraceString(e))
            return false.toFREObject()
        }
        return true.toFREObject()
    }

    fun getAppInstanceId(ctx: FREContext, argv: FREArgv): FREObject? {
        return appInstanceId?.toFREObject()
    }

    fun logEvent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val name = String(argv[0]) ?: return null
        val params: Map<String, Any> = Map(argv[1]) ?: return null
        val bundle = params.toBundle()
        analytics.logEvent(name, bundle)
        return null
    }

    fun setAnalyticsCollectionEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val enabled = Boolean(argv[0]) ?: return null
        analytics.setAnalyticsCollectionEnabled(enabled)
        return null
    }

    fun setCurrentScreen(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val screenName = String(argv[0]) ?: return null
        analytics.setCurrentScreen(ctx.activity, screenName, null)
        return null
    }

    fun setSessionTimeoutDuration(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val milliseconds = Long(argv[0]) ?: return null
        analytics.setSessionTimeoutDuration(milliseconds)
        return null
    }

    fun setUserId(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val id = String(argv[0]) ?: return null
        analytics.setUserId(id)
        return null
    }

    fun setUserProperty(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val name = String(argv[0]) ?: return null
        val value = String(argv[1]) ?: return null
        analytics.setUserProperty(name, value)
        return null
    }

    fun resetAnalyticsData(ctx: FREContext, argv: FREArgv): FREObject? {
        analytics.resetAnalyticsData()
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