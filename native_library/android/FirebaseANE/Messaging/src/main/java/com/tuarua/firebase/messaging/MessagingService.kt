package com.tuarua.firebase.messaging

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.tuarua.firebase.messaging.events.MessageEvent
import org.greenrobot.eventbus.EventBus

class MessagingService() : FirebaseMessagingService() {
    override fun onMessageReceived(remoteMessage: RemoteMessage?) {
        if (remoteMessage != null) {

            if (remoteMessage.data.isNotEmpty()) {
                // TODO handle message data
            }

            val bodyLocalizationArgs = mutableListOf<String>()
            val bodyLocalizationArgsArr = remoteMessage.notification?.bodyLocalizationArgs
            bodyLocalizationArgsArr?.mapTo(bodyLocalizationArgs) { it.toString() }

            val titleLocalizationArgs = mutableListOf<String>()
            val titleLocalizationArgsArr = remoteMessage.notification?.titleLocalizationArgs
            titleLocalizationArgsArr?.mapTo(titleLocalizationArgs) { it.toString() }

            EventBus.getDefault().post(
                    MessageEvent(MessageEvent.ON_MESSAGE_RECEIVED,
                            mapOf("from" to remoteMessage.from,
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
                                            "link" to remoteMessage.notification?.link.toString(),
                                            "bodyLocalizationKey" to remoteMessage.notification?.bodyLocalizationKey,
                                            "bodyLocalizationArgs" to bodyLocalizationArgs,
                                            "titleLocalizationKey" to remoteMessage.notification?.titleLocalizationKey,
                                            "titleLocalizationArgs" to titleLocalizationArgs
                                    )
                            )
                    )
            )

        }

    }

    val TAG: String
        get() = this::class.java.canonicalName
}