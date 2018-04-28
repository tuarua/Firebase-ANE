package com.tuarua.firebase.remoteconfig

import android.util.Log
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigInfo
import com.google.gson.Gson
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.FreKotlinController
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import com.tuarua.firebase.remoteconfig.events.RemoteConfigErrorEvent
import com.tuarua.firebase.remoteconfig.events.RemoteConfigEvent


class RemoteConfigController(override var context: FREContext?) : FreKotlinController {
    private lateinit var remoteConfig: FirebaseRemoteConfig
    private var cacheExpiration: Long = 86400
    private val gson = Gson()

    init {
        try {
            val app = FirebaseApp.getInstance()
            if (app != null) {
                remoteConfig = FirebaseRemoteConfig.getInstance()
            } else {
                trace(">>>>>>>>>>NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
            }
        } catch (e: FreException) {
            trace(e.message)
            trace(e.stackTrace)
        } catch (e: Exception) {
            Log.e(TAG, e.message)
            e.printStackTrace()
        }
    }

    fun setConfigSettings(developerModeEnabled: Boolean) {
        val configSettings = FirebaseRemoteConfigSettings.Builder()
                .setDeveloperModeEnabled(developerModeEnabled)
                .build()
        remoteConfig.setConfigSettings(configSettings)
    }

    fun setDefaults(value: Map<String, Any>) {
        remoteConfig.setDefaults(value)
    }

    fun getByteArray(key: String): ByteArray? = remoteConfig.getByteArray(key)
    fun getBoolean(key: String): Boolean = remoteConfig.getBoolean(key)
    fun getDouble(key: String): Double = remoteConfig.getDouble(key)
    fun getLong(key: String): Long = remoteConfig.getLong(key)
    fun getString(key: String): String = remoteConfig.getString(key)
    fun getKeysByPrefix(prefix: String): List<String> = remoteConfig.getKeysByPrefix(prefix).toList()

    fun getInfo(): FirebaseRemoteConfigInfo? {
        return remoteConfig.info
    }

    fun fetch(cacheExpiration: Long) {
        when {
            remoteConfig.info.configSettings.isDeveloperModeEnabled -> this.cacheExpiration = 0
            else -> this.cacheExpiration = cacheExpiration
        }
        remoteConfig.fetch(this.cacheExpiration).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                sendEvent(RemoteConfigEvent.FETCH, "")
            } else {
                val error = task.exception
                sendEvent(RemoteConfigErrorEvent.FETCH_ERROR, gson.toJson(RemoteConfigErrorEvent(error?.message, 0)))
                //FirebaseRemoteConfigFetchThrottledException
                //FirebaseRemoteConfigFetchThrottledException
            }
        }
    }

    fun activateFetched() {
        remoteConfig.activateFetched()
    }

    override val TAG: String
        get() = this::class.java.simpleName


}