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

package com.tuarua.onesignal

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.gson.Gson
import com.onesignal.*
import com.onesignal.OneSignal.*
import com.tuarua.frekotlin.*
import com.tuarua.onesignal.data.*
import com.tuarua.onesignal.extensions.toFREObject

import org.json.JSONObject
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController,
        OSSubscriptionObserver, OSPermissionObserver, OSEmailSubscriptionObserver, IdsAvailableHandler,
        NotificationOpenedHandler, NotificationReceivedHandler {
    private val gson = Gson()
    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 5 } ?: return FreArgException()
        val autoPromptLocation = Boolean(argv[1]) == true
        val disableGmsMissingPrompt = Boolean(argv[2]) == true
        val filterOtherGCMReceivers = Boolean(argv[3]) == true
        val unsubscribeWhenNotificationsAreDisabled = Boolean(argv[4]) == true
        val inFocusDisplaying = when (Int(argv[5])) {
            1 -> OSInFocusDisplayOption.InAppAlert
            2 -> OSInFocusDisplayOption.Notification
            else -> OSInFocusDisplayOption.None
        }

        startInit(ctx.activity)
                .setNotificationOpenedHandler(this)
                .setNotificationReceivedHandler(this)
                .autoPromptLocation(autoPromptLocation)
                .disableGmsMissingPrompt(disableGmsMissingPrompt)
                .filterOtherGCMReceivers(filterOtherGCMReceivers)
                .unsubscribeWhenNotificationsAreDisabled(unsubscribeWhenNotificationsAreDisabled)
                .inFocusDisplaying(inFocusDisplaying)
                .init()
        idsAvailable(this)
        addEmailSubscriptionObserver(this)
        addPermissionObserver(this)
        addSubscriptionObserver(this)
        return null
    }

    fun getVersion(ctx: FREContext, argv: FREArgv): FREObject? {
        return VERSION.toFREObject()
    }

    fun getSdkType(ctx: FREContext, argv: FREArgv): FREObject? {
        return sdkType.toFREObject()
    }

    fun setLogLevel(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val logLevel = Int(argv[0]) ?: return null
        val visualLevel = Int(argv[1]) ?: return null
        setLogLevel(logLevel, visualLevel)
        return null
    }

    fun setInFocusDisplaying(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val type = Int(argv[0]) ?: return null
        setInFocusDisplaying(type)
        return null
    }

    fun setRequiresUserPrivacyConsent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        setRequiresUserPrivacyConsent(Boolean(argv[0]) == true)
        return null
    }

    fun consentGranted(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        provideUserConsent(Boolean(argv[0]) == true)
        return null
    }

    fun userProvidedPrivacyConsent(ctx: FREContext, argv: FREArgv): FREObject? {
        return userProvidedPrivacyConsent().toFREObject()
    }

    fun setLocationShared(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        setLocationShared(Boolean(argv[0]) == true)
        return null
    }

    fun promptLocation(ctx: FREContext, argv: FREArgv): FREObject? {
        promptLocation()
        return null
    }

    fun sendTag(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val value = String(argv[1]) ?: return null
        sendTag(key, value)
        return null
    }

    fun sendTags(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val json = String(argv[0]) ?: return null
        sendTags(json)
        return null
    }

    fun getTags(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        getTags { result ->
            dispatchEvent(OneSignalEvent.ON_GET_TAGS,
                    Gson().toJson(OneSignalEvent(callbackId,
                            mapOf("results" to result.toString())))
            )
        }
        return null
    }

    fun deleteTag(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        deleteTag(key)
        return null
    }

    fun deleteTags(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val keys = List<String>(argv[0])
        deleteTags(keys)
        return null
    }

    fun setEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException()
        val email = String(argv[0]) ?: return null
        val emailAuthHash = String(argv[1])
        val callbackSuccessId = String(argv[2])
        val callbackFailureId = String(argv[3])

        setEmail(email, emailAuthHash, object : EmailUpdateHandler {
            override fun onSuccess() {
                if (callbackSuccessId == null) return
                dispatchEvent(OneSignalEvent.ON_SET_EMAIL_SUCCESS,
                        Gson().toJson(OneSignalEvent(callbackSuccessId))
                )
            }

            override fun onFailure(error: EmailUpdateError) {
                if (callbackFailureId == null) return
                dispatchEvent(OneSignalEvent.ON_SET_EMAIL_FAILURE,
                        Gson().toJson(OneSignalEvent(callbackFailureId, null,
                                mapOf("id" to error.type.ordinal,
                                        "text" to error.message)))
                )
            }
        })
        return null
    }

    fun logoutEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        logoutEmail()
        return null
    }

    fun addTrigger(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val fre1: FREObject = argv[0]
        val value: Any? = when (fre1.type) {
            FreObjectTypeKotlin.INT -> {
                Int(fre1)
            }
            FreObjectTypeKotlin.STRING -> {
                String(fre1)
            }
            else -> return FreException("value passed to addTrigger must be an int or a String").getError()
        }
        addTrigger(key, value)
        return null
    }

    fun addTriggers(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val json = String(argv[0]) ?: return null
        addTriggersFromJsonString(json)
        return null
    }

    fun removeTriggerForKey(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        removeTriggerForKey(key)
        return null
    }

    fun removeTriggersForKeys(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val keys = List<String>(argv[0])
        removeTriggersForKeys(keys)
        return null
    }

    fun getTriggerValueForKey(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        return gson.toJson(getTriggerValueForKey(key)).toFREObject()
    }

    fun pauseInAppMessages(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        pauseInAppMessages(Boolean(argv[0]) == true)
        return null
    }

    fun getPermissionSubscriptionState(ctx: FREContext, argv: FREArgv): FREObject? {
        return getPermissionSubscriptionState().toFREObject()
    }

    fun setSubscription(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        setSubscription(Boolean(argv[0]) == true)
        return null
    }

    @Suppress("LABEL_NAME_CLASH")
    fun setExternalUserId(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val userId = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        setExternalUserId(userId) { results ->
            if (callbackId == null) return@setExternalUserId
            dispatchEvent(OneSignalEvent.ON_SET_EXTERNAL_USERID,
                    Gson().toJson(OneSignalEvent(callbackId,
                            mapOf("results" to results.toString())))
            )
        }
        return null
    }

    @Suppress("LABEL_NAME_CLASH")
    fun removeExternalUserId(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0])
        removeExternalUserId { results ->
            if (callbackId == null) return@removeExternalUserId
            dispatchEvent(OneSignalEvent.ON_REMOVE_EXTERNAL_USERID,
                    Gson().toJson(OneSignalEvent(callbackId,
                            mapOf("results" to results.toString())))
            )
        }
        return null
    }

    fun postNotification(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val json = String(argv[0]) ?: return null
        val callbackSuccessId = String(argv[1])
        val callbackFailureId = String(argv[2])

        postNotification(json, object : PostNotificationResponseHandler {
            override fun onSuccess(response: JSONObject) {
                if (callbackSuccessId == null) return
                dispatchEvent(OneSignalEvent.ON_POST_NOTIFICATION_SUCCESS,
                        Gson().toJson(OneSignalEvent(callbackSuccessId,
                                mapOf("response" to response.toString())))
                )
            }

            override fun onFailure(response: JSONObject) {
                if (callbackFailureId == null) return
                dispatchEvent(OneSignalEvent.ON_POST_NOTIFICATION_FAILURE,
                        Gson().toJson(OneSignalEvent(callbackFailureId, null,
                                mapOf("id" to 0, "text" to "")))
                )
            }
        })
        return null
    }

    fun cancelNotification(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val id = Int(argv[0]) ?: return null
        cancelNotification(id)
        return null
    }

    fun clearOneSignalNotifications(ctx: FREContext, argv: FREArgv): FREObject? {
        clearOneSignalNotifications()
        return null
    }

    fun enableVibrate(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        enableVibrate(Boolean(argv[0]) == true)
        return null
    }

    fun enableSound(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        enableSound(Boolean(argv[0]) == true)
        return null
    }

    override fun onOSSubscriptionChanged(stateChanges: OSSubscriptionStateChanges?) {
        if (stateChanges == null) return
        dispatchEvent(SubscriptionEvent.ON_AVAILABLE,
                Gson().toJson(SubscriptionEvent(stateChanges.toJSONObject().toString()))
        )
    }

    override fun onOSPermissionChanged(stateChanges: OSPermissionStateChanges?) {
        if (stateChanges == null) return
        dispatchEvent(PermissionEvent.ON_AVAILABLE,
                Gson().toJson(PermissionEvent(stateChanges.toJSONObject().toString()))
        )
    }

    override fun onOSEmailSubscriptionChanged(stateChanges: OSEmailSubscriptionStateChanges?) {
        if (stateChanges == null) return
        dispatchEvent(EmailSubscriptionEvent.ON_AVAILABLE,
                Gson().toJson(EmailSubscriptionEvent(stateChanges.toJSONObject().toString()))
        )
    }

    override fun idsAvailable(userId: String?, registrationId: String?) {
        dispatchEvent(IdsEvent.ON_AVAILABLE,
                Gson().toJson(IdsEvent(userId, registrationId))
        )
    }

    override fun notificationOpened(result: OSNotificationOpenResult?) {
        if (result == null) return
        dispatchEvent(NotificationEvent.OPENED,
                Gson().toJson(NotificationEvent(result.toJSONObject().toString()))
        )
    }

    override fun notificationReceived(notification: OSNotification?) {
        if (notification == null) return
        if (!notification.isAppInFocus) return

        dispatchEvent(NotificationEvent.RECEIVED,
                Gson().toJson(NotificationEvent(notification.toJSONObject().toString()))
        )
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
