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
package com.tuarua.firebase.messaging

import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.content.res.Configuration
import android.os.Build
import com.adobe.air.AndroidActivityWrapper.*
import com.adobe.air.AndroidActivityWrapper.ActivityState.*
import com.adobe.air.FreKotlinActivityResultCallback
import com.adobe.air.FreKotlinStateChangeCallback
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.messaging.FirebaseMessaging
import com.google.gson.Gson
import com.tuarua.firebase.messaging.events.MessageEvent
import com.tuarua.frekotlin.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.util.*
import kotlin.concurrent.schedule

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController, FreKotlinStateChangeCallback, FreKotlinActivityResultCallback {
    private val gson = Gson()

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        EventBus.getDefault().register(this)
        val channelId = String(argv[0]) ?: "fcm_default_channel"
        val channelName = String(argv[1])

        val appActivity = ctx.activity ?: return true.toFREObject()
        if (channelName != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                appActivity.getSystemService(NotificationManager::class.java)
            } else {
                null
            }
            notificationManager?.createNotificationChannel(NotificationChannel(channelId,
                    channelName, NotificationManager.IMPORTANCE_LOW))
        }

        if (appActivity.intent.extras != null) {
            sendMessageFromExtras(appActivity)
        }
        return true.toFREObject()
    }

    fun getToken(ctx: FREContext, argv: FREArgv): FREObject? {
        return FirebaseInstanceId.getInstance().token?.toFREObject()
    }

    fun subscribe(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val toTopic = String(argv[0]) ?: return null
        FirebaseMessaging.getInstance().subscribeToTopic(toTopic)
        return null
    }

    fun unsubscribe(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val fromTopic = String(argv[0]) ?: return null
        FirebaseMessaging.getInstance().unsubscribeFromTopic(fromTopic)
        return null
    }

    @Throws(FreException::class)
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: MessageEvent) {
        if (_context != null) {
            dispatchEvent(event.callbackId, gson.toJson(MessageEvent(event.callbackId, event.data)))
        }
    }

    private fun sendMessageFromExtras(appActivity: Activity) {
        val extras = appActivity.intent.extras ?: return
        if (extras.isEmpty) return
        var from: String? = null
        var ttl = 0
        var messageId: String? = null
        var sentTime: Long = 0
        var collapseKey: String? = null
        val data = mutableMapOf<String, String>()

        if (extras.keySet().contains("google.message_id")) {
            for (key in extras.keySet()) {
                val value = extras.get(key)

                when (key) {
                    "google.sent_time" -> sentTime = value as Long
                    "google.ttl" -> ttl = value as Int
                    "from" -> from = value as String
                    "google.message_id" -> messageId = value as String
                    "collapse_key" -> collapseKey = value as String
                    else -> {
                        data[key] = value as String
                    }
                }
                appActivity.intent.removeExtra(key)
            }

            val payload = mapOf(
                    "from" to from,
                    "data" to data,
                    "messageId" to messageId,
                    "collapseKey" to collapseKey,
                    "sentTime" to sentTime,
                    "ttl" to ttl
            )
            Timer("IntentMessageEvent", false).schedule(500) {
                dispatchEvent(MessageEvent.ON_MESSAGE_RECEIVED,
                        gson.toJson(MessageEvent(MessageEvent.ON_MESSAGE_RECEIVED, payload)))
            }
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
    }

    override fun onConfigurationChanged(configuration: Configuration?) {
    }

    override fun onActivityStateChanged(activityState: ActivityState?) {
        when (activityState) {
            STARTED -> return
            RESTARTED -> return
            RESUMED -> {
                val appActivity = _context?.activity ?: return
                if (appActivity.intent.extras != null) {
                    sendMessageFromExtras(appActivity)
                }
            }
            PAUSED -> return
            STOPPED -> return
            DESTROYED -> return
        }
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

