package com.tuarua.firebase.remoteconfig

import android.util.Log
import com.adobe.fre.FREByteArray
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.FirebaseApp
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigException
import com.google.gson.Gson
import com.tuarua.firebase.remoteconfig.events.RemoteConfigErrorEvent
import com.tuarua.firebase.remoteconfig.events.RemoteConfigEvent
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var remoteConfig: FirebaseRemoteConfig
    private var cacheExpiration: Long = 86400
    private val gson = Gson()

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            val app = FirebaseApp.getInstance()
            if (app != null) {
                remoteConfig = FirebaseRemoteConfig.getInstance()
            } else {
                trace(">>>>>>>>>>NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
                return false.toFREObject()
            }
        } catch (e: FreException) {
            trace(e.message)
            trace(e.stackTrace)
            return false.toFREObject()
        } catch (e: Exception) {
            Log.e(TAG, e.message)
            e.printStackTrace()
            return false.toFREObject()
        }
        return true.toFREObject()
    }

    fun setConfigSettings(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setConfigSettings")
        val settings = FirebaseRemoteConfigSettings(argv[0]) ?: return FreConversionException("settings")
        remoteConfig.setConfigSettings(settings)
        return null
    }

    fun setDefaults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setDefaults")
        val defaults: Map<String, Any> = Map(argv[0]) ?: return FreConversionException("defaults")
        remoteConfig.setDefaults(defaults)
        return null
    }

    fun getByteArray(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getByteArray")
        val key = String(argv[0]) ?: return FreConversionException("key")
        try {
            val ba = remoteConfig.getByteArray(key) ?: return null
            val ret = FREByteArray.newByteArray()
            ret.setProp("length", ba.size)
            ret.acquire()
            ret.bytes.get(ba)
            ret.release()
            return ret
        } catch (e: FreException) {
            e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun getBoolean(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getBoolean")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfig.getBoolean(key).toFREObject()
    }

    fun getDouble(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getDouble")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfig.getDouble(key).toFREObject()
    }

    fun getLong(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getLong")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfig.getLong(key).toFREObject()
    }

    fun getString(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getString")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfig.getString(key).toFREObject()
    }

    fun getKeysByPrefix(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getKeysByPrefix")
        val prefix = String(argv[0]) ?: return FreConversionException("prefix")
        return remoteConfig.getKeysByPrefix(prefix).toList().toFREArray()
    }

    fun fetch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("fetch")
        val cacheExpiration = Long(argv[0]) ?: return FreConversionException("cacheExpiration")
        when {
            remoteConfig.info.configSettings.isDeveloperModeEnabled -> this.cacheExpiration = 0
            else -> this.cacheExpiration = cacheExpiration
        }
        remoteConfig.fetch(this.cacheExpiration).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                sendEvent(RemoteConfigEvent.FETCH, "")
            } else {
                val error = task.exception as FirebaseRemoteConfigException
                sendEvent(RemoteConfigErrorEvent.FETCH_ERROR, gson.toJson(RemoteConfigErrorEvent(error.message, 0)))
            }
        }
        return null
    }

    fun activateFetched(ctx: FREContext, argv: FREArgv): FREObject? {
        remoteConfig.activateFetched()
        return null
    }

    fun getInfo(ctx: FREContext, argv: FREArgv): FREObject? {
       return remoteConfig.getInfo()?.toFREObject()
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