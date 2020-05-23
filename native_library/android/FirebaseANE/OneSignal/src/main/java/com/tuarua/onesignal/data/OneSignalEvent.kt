/*
 * Copyright 2020 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.onesignal.data

data class OneSignalEvent(val callbackId: String?,
                          val data: Map<String, Any?>? = null,
                          val error: Map<String, Any>? = null) {
    companion object {
        const val ON_SET_EXTERNAL_USERID = "OneSignalEvent.OnSetExternalUserId"
        const val ON_REMOVE_EXTERNAL_USERID = "OneSignalEvent.OnRemoveExternalUserId"
        const val ON_POST_NOTIFICATION_SUCCESS = "OneSignalEvent.OnPostNotificationSuccess"
        const val ON_POST_NOTIFICATION_FAILURE = "OneSignalEvent.OnPostNotificationFailure"
        const val ON_GET_TAGS = "OneSignalEvent.OnGetTags"
        const val ON_SET_EMAIL_SUCCESS = "OneSignalEvent.OnSetEmailSuccess"
        const val ON_SET_EMAIL_FAILURE = "OneSignalEvent.OnSetEmailFailure"
    }
}

data class IdsEvent(val userId: String?, val registrationId: String?) {
    companion object {
        const val ON_AVAILABLE = "IdsEvent.OnAvailable"
    }
}

data class PermissionEvent(val json: String) {
    companion object {
        const val ON_AVAILABLE = "PermissionEvent.OnChange"
    }
}

data class SubscriptionEvent(val json: String) {
    companion object {
        const val ON_AVAILABLE = "SubscriptionEvent.OnChange"
    }
}

data class EmailSubscriptionEvent(val json: String) {
    companion object {
        const val ON_AVAILABLE = "EmailSubscriptionEvent.OnChange"
    }
}
data class NotificationEvent(val json: String) {
    companion object {
        const val OPENED = "NotificationEvent.Opened"
        const val RECEIVED = "NotificationEvent.Received"
    }
}

