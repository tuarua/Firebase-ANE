/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua.firebase.remoteconfig

import android.util.Log
import com.adobe.fre.FREByteArray
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ktx.Firebase
import com.google.firebase.ktx.app
import com.google.firebase.remoteconfig.ktx.remoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigException
import com.google.firebase.remoteconfig.ktx.get

import com.google.gson.Gson
import com.tuarua.firebase.remoteconfig.events.RemoteConfigErrorEvent
import com.tuarua.firebase.remoteconfig.events.RemoteConfigEvent
import com.tuarua.firebase.remoteconfig.extensions.FirebaseRemoteConfigSettings
import com.tuarua.firebase.remoteconfig.extensions.toFREObject
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private lateinit var remoteConfig: FirebaseRemoteConfig
    private var cacheExpiration: Long = 86400
    private val gson = Gson()

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            remoteConfig = Firebase.remoteConfig(Firebase.app)
        } catch (e: FreException) {
            warning(e.message)
            warning(e.stackTrace)
            return false.toFREObject()
        } catch (e: Exception) {
            warning(e.message)
            warning(Log.getStackTraceString(e))
            return false.toFREObject()
        }
        return true.toFREObject()
    }

    fun setConfigSettings(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val settings = FirebaseRemoteConfigSettings(argv[0]) ?: return null
        remoteConfig.setConfigSettingsAsync(settings)
        return null
    }

    fun setDefaults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val defaults: Map<String, Any> = Map(argv[0]) ?: return null
        remoteConfig.setDefaultsAsync(defaults)
        return null
    }

    fun getByteArray(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        try {
            val ba = remoteConfig[key].asByteArray()
            val ret = FREByteArray.newByteArray()
            ret["length"] = ba.size
            ret.acquire()
            ret.bytes.get(ba)
            ret.release()
            return ret
        } catch (e: FreException) {
            e.getError()
        } catch (e: Exception) {
            FreException(e).getError()
        }
        return null
    }

    fun getBoolean(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        return remoteConfig[key].asBoolean().toFREObject()
    }

    fun getDouble(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        return remoteConfig[key].asDouble().toFREObject()
    }

    fun getLong(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        return remoteConfig[key].asLong().toFREObject()
    }

    fun getString(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        return remoteConfig[key].asString().toFREObject()
    }

    fun getKeysByPrefix(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val prefix = String(argv[0]) ?: return null
        return remoteConfig.getKeysByPrefix(prefix).toList().toFREObject()
    }

    fun fetch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val cacheExpiration = Long(argv[0]) ?: return null
        when {
            remoteConfig.info.configSettings.isDeveloperModeEnabled -> this.cacheExpiration = 0
            else -> this.cacheExpiration = cacheExpiration
        }
        remoteConfig.fetch(this.cacheExpiration).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                dispatchEvent(RemoteConfigEvent.FETCH, "")
            } else {
                val error = task.exception as FirebaseRemoteConfigException
                dispatchEvent(RemoteConfigErrorEvent.FETCH_ERROR, gson.toJson(RemoteConfigErrorEvent(error.message, 0)))
            }
        }
        return null
    }

    fun activateFetched(ctx: FREContext, argv: FREArgv): FREObject? {
        return remoteConfig.activateFetched().toFREObject()
    }

    fun activate(ctx: FREContext, argv: FREArgv): FREObject? {
        remoteConfig.activate().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                dispatchEvent(RemoteConfigEvent.FETCH, "")
            } else {
                val error = task.exception as FirebaseRemoteConfigException
                dispatchEvent(RemoteConfigErrorEvent.ACTIVATE_ERROR, gson.toJson(RemoteConfigErrorEvent(error.message, 0)))
            }
        }
        return null
    }

    fun fetchAndActivate(ctx: FREContext, argv: FREArgv): FREObject? {
        remoteConfig.fetchAndActivate().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                dispatchEvent(RemoteConfigEvent.FETCH, "")
            } else {
                val error = task.exception as FirebaseRemoteConfigException
                dispatchEvent(RemoteConfigErrorEvent.FETCH_ERROR, gson.toJson(RemoteConfigErrorEvent(error.message, 0)))
            }
        }
        return null
    }

    fun getInfo(ctx: FREContext, argv: FREArgv): FREObject? {
        return remoteConfig.info.toFREObject()
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