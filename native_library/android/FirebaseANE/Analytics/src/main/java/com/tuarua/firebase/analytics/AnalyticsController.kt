package com.tuarua.firebase.analytics

import android.os.Bundle
import android.util.Log
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.analytics.FirebaseAnalytics
import com.tuarua.frekotlin.FreKotlinController


class AnalyticsController(override var context: FREContext?) : FreKotlinController {
    private lateinit var analytics: FirebaseAnalytics

    init {
        try {
            val ac = context?.activity
            if (isDefaultFirebaseAppInitialized() && ac != null) {
                analytics = FirebaseAnalytics.getInstance(ac)
            } else {
                trace("Firebase is NOT initialised")
            }
        } catch (e: Exception) {
            trace("analytics Exception", e.message)
            Log.e(TAG, "analytics Exception", e)
            e.printStackTrace()
        }
    }

    private fun isDefaultFirebaseAppInitialized(): Boolean {
        return try {
            FirebaseApp.getInstance(FirebaseApp.DEFAULT_APP_NAME) != null
        } catch (e: IllegalStateException) {
            Log.e(TAG, "isDefaultFirebaseAppInitialized", e)
            trace(e.message)
            false
        }
    }

    fun setUserProperty(name: String, value: String) = analytics.setUserProperty(name, value)
    fun setUserId(id: String) = analytics.setUserId(id)
    fun setSessionTimeoutDuration(milliseconds: Long) = analytics.setSessionTimeoutDuration(milliseconds)
    fun setMinimumSessionDuration(milliseconds: Long) = analytics.setMinimumSessionDuration(milliseconds)
    fun setAnalyticsCollectionEnabled(enabled: Boolean) = analytics.setAnalyticsCollectionEnabled(enabled)

    fun setCurrentScreen(screenName: String) {
        val ctx = context ?: return
        analytics.setCurrentScreen(ctx.activity, screenName, null)
    }

    fun resetAnalyticsData() {
        analytics.resetAnalyticsData()
    }

    fun logEvent(name: String, params: Bundle) {
        analytics.logEvent(name, params)
    }

    override val TAG: String
        get() = this::class.java.simpleName
}