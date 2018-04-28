package com.tuarua.firebase.remoteconfig

import com.adobe.fre.FREByteArray
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var remoteConfigController: RemoteConfigController

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        remoteConfigController = RemoteConfigController(context)
        return true.toFREObject()
    }

    fun setConfigSettings(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setConfigSettings")

        val developerModeEnabled = Boolean(argv[0]["developerModeEnabled"])
                ?: return FreConversionException("developerModeEnabled")
        remoteConfigController.setConfigSettings(developerModeEnabled)
        return null
    }

    fun setDefaults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setDefaults")
        val defaults: Map<String, Any> = Map(argv[0]) ?: return FreConversionException("defaults")
        remoteConfigController.setDefaults(defaults)
        return null
    }

    fun getByteArray(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getByteArray")
        val key = String(argv[0]) ?: return FreConversionException("key")
        try {
            val ba = remoteConfigController.getByteArray(key) ?: return null
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
        return remoteConfigController.getBoolean(key).toFREObject()
    }

    fun getDouble(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getDouble")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfigController.getDouble(key).toFREObject()
    }

    fun getLong(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getLong")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfigController.getLong(key).toFREObject()
    }

    fun getString(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getString")
        val key = String(argv[0]) ?: return FreConversionException("key")
        return remoteConfigController.getString(key).toFREObject()
    }

    fun getKeysByPrefix(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getKeysByPrefix")
        val prefix = String(argv[0]) ?: return FreConversionException("prefix")
        return remoteConfigController.getKeysByPrefix(prefix).toFREArray()
    }

    fun fetch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("fetch")
        val cacheExpiration = Long(argv[0]) ?: return FreConversionException("cacheExpiration")
        remoteConfigController.fetch(cacheExpiration)
        return null
    }

    fun activateFetched(ctx: FREContext, argv: FREArgv): FREObject? {
        remoteConfigController.activateFetched()
        return null
    }

    @Suppress("LiftReturnOrAssignment")
    fun getInfo(ctx: FREContext, argv: FREArgv): FREObject? {
        val info = remoteConfigController.getInfo() ?: return null // TODO convert to Extension
        try {
            val ret = FREObject("com.tuarua.firebase.remoteconfig.RemoteConfigInfo")
            val remoteConfigSettings = FREObject(
                    "com.tuarua.firebase.remoteconfig.RemoteConfigSettings",
                    info.configSettings.isDeveloperModeEnabled
            )
            ret.setProp("fetchTimeMillis", info.fetchTimeMillis)
            ret.setProp("lastFetchStatus", info.lastFetchStatus)
            ret.setProperty("configSettings", remoteConfigSettings)
            return ret
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
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