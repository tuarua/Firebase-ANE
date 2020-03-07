package com.tuarua.firebase.messaging

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.tuarua.firebase.messaging.events.MessageEvent
import org.greenrobot.eventbus.EventBus

class MessagingService : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val bodyLocalizationArgs = mutableListOf<String>()
        val bodyLocalizationArgsArr = remoteMessage.notification?.bodyLocalizationArgs
        bodyLocalizationArgsArr?.mapTo(bodyLocalizationArgs) { it.toString() }
        val titleLocalizationArgs = mutableListOf<String>()
        val titleLocalizationArgsArr = remoteMessage.notification?.titleLocalizationArgs
        titleLocalizationArgsArr?.mapTo(titleLocalizationArgs) { it.toString() }
        val link = if (remoteMessage.notification?.link != null) {
            remoteMessage.notification?.link.toString()
        } else {
            null
        }
        val payload = mapOf(
                "from" to remoteMessage.from,
                "data" to remoteMessage.data,
                "messageId" to remoteMessage.messageId,
                "messageType" to remoteMessage.messageType,
                "to" to remoteMessage.to,
                "collapseKey" to remoteMessage.collapseKey,
                "sentTime" to remoteMessage.sentTime,
                "ttl" to remoteMessage.ttl,
                "notification" to mapOf(
                        "body" to remoteMessage.notification?.body,
                        "clickAction" to remoteMessage.notification?.clickAction,
                        "color" to remoteMessage.notification?.color,
                        "icon" to remoteMessage.notification?.icon,
                        "sound" to remoteMessage.notification?.sound,
                        "tag" to remoteMessage.notification?.tag,
                        "title" to remoteMessage.notification?.title,
                        "link" to link,
                        "bodyLocalizationKey" to remoteMessage.notification?.bodyLocalizationKey,
                        "bodyLocalizationArgs" to bodyLocalizationArgs,
                        "titleLocalizationKey" to remoteMessage.notification?.titleLocalizationKey,
                        "titleLocalizationArgs" to titleLocalizationArgs
                )
        )

        EventBus.getDefault().post(MessageEvent(MessageEvent.ON_MESSAGE_RECEIVED, payload))
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        EventBus.getDefault().post(MessageEvent(MessageEvent.ON_TOKEN_REFRESHED, mapOf("token" to token)))
    }
}