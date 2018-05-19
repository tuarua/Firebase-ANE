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
package com.tuarua.firebase.invites

import android.net.Uri
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import java.util.*
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.gson.Gson
import com.google.android.gms.appinvite.AppInviteInvitation


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private val gson = Gson()
    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun buildDynamicLink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException("createDynamicLink")
        val linkFre = argv[0]
        val eventId = String(argv[1]) ?: return FreConversionException("eventId")
        val shorten = Boolean(argv[2]) == true
        val suffix = Int(argv[3]) ?: 0

        val link = String(linkFre["link"])
        val dynamicLinkDomain = String(linkFre["dynamicLinkDomain"])
        val iosParameters = IosParameters(linkFre["iosParameters"])
        val androidParameters = AndroidParameters(linkFre["androidParameters"])
                ?: return FreArgException("androidParameters")
        val googleAnalyticsParameters = GoogleAnalyticsParameters(linkFre["googleAnalyticsParameters"])
        val itunesConnectAnalyticsParameters = ItunesConnectAnalyticsParameters(
                linkFre["itunesConnectAnalyticsParameters"]
        )
        val socialMetaTagParameters = SocialMetaTagParameters(linkFre["socialMetaTagParameters"])
        val navigationInfoParameters = NavigationInfoParameters(linkFre["navigationInfoParameters"])

        val builder = FirebaseDynamicLinks.getInstance().createDynamicLink()
        if (!link.isNullOrEmpty()) {
            builder.setLink(Uri.parse(link))
        }
        if (dynamicLinkDomain != null && !dynamicLinkDomain.isNullOrEmpty()) {
            builder.setDynamicLinkDomain(dynamicLinkDomain)
        }
        builder.setAndroidParameters(androidParameters)
        if (iosParameters != null) {
            builder.setIosParameters(iosParameters)
        }
        if (googleAnalyticsParameters != null) {
            builder.setGoogleAnalyticsParameters(googleAnalyticsParameters)
        }
        if (itunesConnectAnalyticsParameters != null) {
            builder.setItunesConnectAnalyticsParameters(itunesConnectAnalyticsParameters)
        }
        if (socialMetaTagParameters != null) {
            builder.setSocialMetaTagParameters(socialMetaTagParameters)
        }
        if (navigationInfoParameters != null) {
            builder.setNavigationInfoParameters(navigationInfoParameters)
        }
        if (shorten) {
            val dynamicLink = builder.buildShortDynamicLink(suffix)
            dynamicLink.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val warnings: MutableList<String> = mutableListOf()
                    task.result.warnings.mapTo(warnings) { it.message }
                    sendEvent(DynamicLinkEvent.ON_CREATED,
                            gson.toJson(
                                    DynamicLinkEvent(eventId, true, mapOf(
                                            "previewLink" to task.result.previewLink.toString(),
                                            "shortLink" to task.result.shortLink.toString(),
                                            "warnings" to warnings))
                            )
                    )
                } else {
                    val error = task.exception
                    sendEvent(DynamicLinkEvent.ON_CREATED, gson.toJson(
                            DynamicLinkEvent(eventId, true, null, mapOf(
                                    "text" to error?.localizedMessage.toString(),
                                    "id" to 0))
                    ))
                }
            }
        } else {
            val dynamicLink = builder.buildDynamicLink()
            sendEvent(DynamicLinkEvent.ON_CREATED,
                    gson.toJson(
                            DynamicLinkEvent(eventId, false, mapOf(
                                    "url" to dynamicLink.uri.toString())
                            )
                    ))
        }
        return null
    }

    fun sendInvite(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("sendInvite")

        val options = argv[0]
        val title = String(options["title"]) ?: return FreConversionException("title")
        val message = String(options["message"])
        val deepLink = String(options["deepLink"])
        val customImageUrl = String(options["customImageUrl"])
        val action = String(options["action"])
        val emailSubject = String(options["emailSubject"])
        val emailHtmlContent = String(options["emailHtmlContent"])
        val googleAnalyticsTrackingId = String(options["googleAnalyticsTrackingId"])
        val iOSClientID = String(options["iOSClientID"])

        val builder = AppInviteInvitation.IntentBuilder(title)
        if (!message.isNullOrEmpty()) builder.setMessage(message)
        if (!deepLink.isNullOrEmpty()) builder.setDeepLink(Uri.parse(deepLink))
        if (!customImageUrl.isNullOrEmpty()) builder.setCustomImage(Uri.parse(customImageUrl))
        if (!action.isNullOrEmpty()) builder.setCallToActionText(action)
        if (!emailSubject.isNullOrEmpty()) builder.setEmailSubject(emailSubject)
        if (!emailHtmlContent.isNullOrEmpty()) builder.setEmailHtmlContent(emailHtmlContent)
        if (!googleAnalyticsTrackingId.isNullOrEmpty()) builder.setGoogleAnalyticsTrackingId(googleAnalyticsTrackingId)
        builder.setOtherPlatformsTargetApplication(1, iOSClientID)

        ctx.activity?.startActivityForResult(builder.build(), 123665)

        return null
    }

    fun getDynamicLink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getDynamicLink")
        val eventId = String(argv[0]) ?: return FreConversionException("eventId")
        val appActivity = ctx.activity
        if (appActivity != null) {
            val task = FirebaseDynamicLinks.getInstance().getDynamicLink(appActivity.intent)
            task.addOnSuccessListener {
                val link = it.link?.toString()
                if (link != null) sendEvent(DynamicLinkEvent.ON_LINK,
                        gson.toJson(
                                DynamicLinkEvent(eventId,false, mapOf(
                                        "url" to link))
                        )
                )
            }
            task.addOnFailureListener {
                sendEvent(DynamicLinkEvent.ON_LINK, gson.toJson(
                        DynamicLinkEvent(eventId,true, null, mapOf(
                                "text" to it.localizedMessage.toString(),
                                "id" to 0))
                ))
            }
        }
        return null
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