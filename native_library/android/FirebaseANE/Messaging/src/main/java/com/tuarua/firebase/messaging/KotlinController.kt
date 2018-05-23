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

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.util.Log
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

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private val gson = Gson()

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("init")
        EventBus.getDefault().register(this)
        val channelId = String(argv[0]) ?: "fcm_default_channel"
        val channelName = String(argv[1])

        val appActivity = ctx.activity
        if (channelName != null && appActivity != null) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val notificationManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    appActivity.getSystemService(NotificationManager::class.java)
                } else {
                    null
                }
                notificationManager?.createNotificationChannel(NotificationChannel(channelId,
                        channelName, NotificationManager.IMPORTANCE_LOW))


                if (appActivity.intent.extras != null) {
                    for (key in appActivity.intent.extras.keySet()) {
                        val value = appActivity.intent.extras.get(key)
                    }
                }

            }
        }



        return true.toFREObject()
    }

    fun getToken(ctx: FREContext, argv: FREArgv): FREObject? {
        return FirebaseInstanceId.getInstance().token?.toFREObject()
    }

    fun subscribe(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("subscribe")
        val toTopic = String(argv[1]) ?: return FreConversionException("toTopic")
        FirebaseMessaging.getInstance().subscribeToTopic(toTopic)
        return null
    }

    fun unsubscribe(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("unsubscribe")
        val fromTopic = String(argv[1]) ?: return FreConversionException("fromTopic")
        FirebaseMessaging.getInstance().unsubscribeFromTopic(fromTopic)
        return null
    }

    @Throws(FreException::class)
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: MessageEvent) {
        sendEvent(event.eventId, gson.toJson(MessageEvent(event.eventId, event.data)))
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

