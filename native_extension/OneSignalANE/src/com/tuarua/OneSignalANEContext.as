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

package com.tuarua {
import com.tuarua.fre.ANEUtils;
import com.tuarua.onesignal.OSEmailSubscriptionState;
import com.tuarua.onesignal.OSNotification;
import com.tuarua.onesignal.OSNotificationOpenResult;
import com.tuarua.onesignal.OSPermissionState;
import com.tuarua.onesignal.OSSubscriptionState;
import com.tuarua.onesignal.events.EmailSubscriptionEvent;
import com.tuarua.onesignal.events.IdsEvent;
import com.tuarua.onesignal.events.NotificationEvent;
import com.tuarua.onesignal.events.PermissionEvent;
import com.tuarua.onesignal.events.SubscriptionEvent;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class OneSignalANEContext {
    internal static const NAME:String = "OneSignalANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .shared";

    private static const ON_SET_EXTERNAL_USERID:String = "OneSignalEvent.OnSetExternalUserId";
    private static const ON_REMOVE_EXTERNAL_USERID:String = "OneSignalEvent.OnRemoveExternalUserId";
    private static const ON_POST_NOTIFICATION_SUCCESS:String = "OneSignalEvent.OnPostNotificationSuccess";
    private static const ON_POST_NOTIFICATION_FAILURE:String = "OneSignalEvent.OnPostNotificationFailure";
    private static const ON_GET_TAGS:String = "OneSignalEvent.OnGetTags";
    private static const ON_SET_EMAIL_SUCCESS:String = "OneSignalEvent.OnSetEmailSuccess";
    private static const ON_SET_EMAIL_FAILURE:String = "OneSignalEvent.OnSetEmailFailure";

    private static var _isInited:Boolean = false;
    private static var _context:ExtensionContext;
    public static var callbacks:Dictionary = new Dictionary();
    public static var callbackCallers:Dictionary = new Dictionary();
    private static var argsAsJSON:Object;

    public function OneSignalANEContext() {
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }
        return _context;
    }

    public static function createCallback(listener:Function, listenerCaller:Object = null):String {
        var id:String;
        if (listener != null) {
            id = context.call("createGUID") as String;
            callbacks[id] = listener;
            if (listenerCaller) {
                callbackCallers[id] = listenerCaller;
            }
        }
        return id;
    }

    private static function callCallback(callbackId:String, ...args):void {
        var callback:Function = callbacks[callbackId];
        if (callback == null) return;
        callback.apply(null, args);
        delete callbacks[callbackId];
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case ON_SET_EXTERNAL_USERID:
            case ON_REMOVE_EXTERNAL_USERID:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, JSON.parse(argsAsJSON.data.results));
                break;
            case ON_POST_NOTIFICATION_SUCCESS:
            case ON_POST_NOTIFICATION_FAILURE:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, argsAsJSON.data.response);
                break;
            case ON_GET_TAGS:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, argsAsJSON.data.results);
                break;
            case ON_SET_EMAIL_SUCCESS:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId);
                break;
            case ON_SET_EMAIL_FAILURE:
                argsAsJSON = JSON.parse(event.code);
                callCallback(argsAsJSON.callbackId, new Error(argsAsJSON.error.text, argsAsJSON.error.id));
                break;
            case IdsEvent.ON_AVAILABLE:
                argsAsJSON = JSON.parse(event.code);
                OneSignal.shared().dispatchEvent(
                        new IdsEvent(event.level, argsAsJSON.userId, argsAsJSON.registrationId));
                break;
            case SubscriptionEvent.ON_CHANGE:
                trace(event.code);
                argsAsJSON = JSON.parse(event.code);
                var parsedA:Object = JSON.parse(argsAsJSON.json);
                OneSignal.shared().dispatchEvent(new SubscriptionEvent(event.level,
                        ANEUtils.map(parsedA.from, OSSubscriptionState) as OSSubscriptionState,
                        ANEUtils.map(parsedA.to, OSSubscriptionState) as OSSubscriptionState));
                break;
            case EmailSubscriptionEvent.ON_CHANGE:
                argsAsJSON = JSON.parse(event.code);
                var parsedB:Object = JSON.parse(argsAsJSON.json);
                OneSignal.shared().dispatchEvent(new EmailSubscriptionEvent(event.level,
                        ANEUtils.map(parsedB.from, OSEmailSubscriptionState) as OSEmailSubscriptionState,
                        ANEUtils.map(parsedB.to, OSEmailSubscriptionState) as OSEmailSubscriptionState));
                break;
            case PermissionEvent.ON_CHANGE:
                trace(event.code);
                argsAsJSON = JSON.parse(event.code);
                var parsedC:Object = JSON.parse(argsAsJSON.json);
                OneSignal.shared().dispatchEvent(new PermissionEvent(event.level,
                        ANEUtils.map(parsedC.from, OSPermissionState) as OSPermissionState,
                        ANEUtils.map(parsedC.to, OSPermissionState) as OSPermissionState));
                break;
            case NotificationEvent.OPENED:
                argsAsJSON = JSON.parse(event.code);
                var parsedD:Object = JSON.parse(argsAsJSON.json);
                OneSignal.shared().dispatchEvent(new NotificationEvent(event.level,
                        ANEUtils.map(parsedD, OSNotificationOpenResult) as OSNotificationOpenResult));
                break;
            case NotificationEvent.RECEIVED:
                argsAsJSON = JSON.parse(event.code);
                var parsedE:Object = JSON.parse(argsAsJSON.json);
                OneSignal.shared().dispatchEvent(new NotificationEvent(event.level, null,
                        ANEUtils.map(parsedE, OSNotification) as OSNotification));
                break;
        }
    }

    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }
}
}
