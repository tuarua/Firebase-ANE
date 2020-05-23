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

package com.tuarua;

import android.annotation.SuppressLint;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.tuarua.onesignal.KotlinController;

@SuppressWarnings("WeakerAccess")
public class OneSignalANE implements FREExtension {
    private static final String[] FUNCTIONS = {
            "init"
            ,"createGUID"
            ,"getVersion"
            ,"getSdkType"
            ,"setLogLevel"
            ,"setInFocusDisplaying"
            ,"setRequiresUserPrivacyConsent"
            ,"consentGranted"
            ,"userProvidedPrivacyConsent"
            ,"setLocationShared"
            ,"promptLocation"
            ,"sendTag"
            ,"sendTags"
            ,"getTags"
            ,"deleteTag"
            ,"deleteTags"
            ,"setEmail"
            ,"logoutEmail"
            ,"addTrigger"
            ,"addTriggers"
            ,"removeTriggerForKey"
            ,"removeTriggersForKeys"
            ,"getTriggerValueForKey"
            ,"pauseInAppMessages"
            ,"getPermissionSubscriptionState"
            ,"setSubscription"
            ,"setExternalUserId"
            ,"removeExternalUserId"
            ,"postNotification"
            ,"cancelNotification"
            ,"clearOneSignalNotifications"
            ,"enableVibrate"
            ,"enableSound"
    };

    private static OneSignalANEContext extensionContext;

    @Override
    public void initialize() {

    }

    @SuppressLint("UnknownNullness")
    @Override
    public FREContext createContext(String s) {
        return extensionContext = new OneSignalANEContext("com.tuarua.OneSignalANE", new KotlinController(), FUNCTIONS);
    }

    @Override
    public void dispose() {
        extensionContext.dispose();
    }
}
