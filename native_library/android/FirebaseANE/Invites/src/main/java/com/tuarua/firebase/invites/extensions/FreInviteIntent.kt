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
package com.tuarua.firebase.invites.extensions

import android.content.Intent
import android.net.Uri
import com.adobe.fre.FREObject
import com.google.android.gms.appinvite.AppInviteInvitation
import com.google.android.gms.appinvite.AppInviteInvitation.IntentBuilder.PlatformMode.PROJECT_PLATFORM_IOS
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun InviteIntent(freObject: FREObject?): Intent? {
    val rv = freObject ?: return null
    val title = String(rv["title"]) ?: return null
    val message = String(rv["message"])
    val deepLink = String(rv["deepLink"])
    val customImage = String(rv["customImage"])
    val callToActionText = String(rv["callToActionText"])
    val emailHtmlContent = String(rv["emailHtmlContent"])
    val emailSubject = String(rv["emailSubject"])
    val otherPlatformClientId = String(rv["otherPlatformClientId"])
    val androidMinimumVersionCode = Int(rv["androidMinimumVersionCode"]) ?: 19

    val builder = AppInviteInvitation.IntentBuilder(title)
    if (message != null) builder.setMessage(message.toString())
    if (deepLink != null) builder.setDeepLink(Uri.parse(deepLink.toString()))
    if (customImage != null) builder.setCustomImage(Uri.parse(customImage.toString()))
    if (callToActionText != null) builder.setCallToActionText(callToActionText.toString())
    if (emailHtmlContent != null) builder.setEmailHtmlContent(emailHtmlContent.toString())
    if (emailSubject != null) builder.setEmailSubject(emailSubject.toString())
    if (otherPlatformClientId != null) builder.setOtherPlatformsTargetApplication(PROJECT_PLATFORM_IOS,
            otherPlatformClientId.toString())
    builder.setAndroidMinimumVersionCode(androidMinimumVersionCode)
    return builder.build()
}