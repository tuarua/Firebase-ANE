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
package com.tuarua.firebase.dynamiclinks

import android.net.Uri
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import java.util.*
import com.google.gson.Gson
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import com.google.firebase.dynamiclinks.ktx.*
import com.google.firebase.ktx.Firebase
import com.tuarua.firebase.dynamiclinks.events.DynamicLinkEvent

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val gson = Gson()

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        return true.toFREObject()
    }

    fun buildDynamicLink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 4 } ?: return FreArgException()
        val linkFre = argv[0]
        val callbackId = String(argv[1]) ?: return null
        val copyToClipboard = Boolean(argv[2]) == true
        val shorten = Boolean(argv[3]) == true
        val _suffix = Int(argv[4]) ?: 0
        val _link = String(linkFre["link"]) ?: return FreArgException()
        val _domainUriPrefix = String(linkFre["domainUriPrefix"]) ?: return FreArgException()
        val _iosParameters = IosParameters(linkFre["iosParameters"])
        val _androidParameters = AndroidParameters(linkFre["androidParameters"])
        val _googleAnalyticsParameters = GoogleAnalyticsParameters(linkFre["googleAnalyticsParameters"])
        val _itunesConnectAnalyticsParameters = ItunesConnectAnalyticsParameters(
                linkFre["itunesConnectAnalyticsParameters"]
        )
        val _socialMetaTagParameters = SocialMetaTagParameters(linkFre["socialMetaTagParameters"])
        val _navigationInfoParameters = NavigationInfoParameters(linkFre["navigationInfoParameters"])

        val dynamicLink = Firebase.dynamicLinks.dynamicLink {
            link = Uri.parse(_link)
            domainUriPrefix = _domainUriPrefix

            iosParameters(_iosParameters.bundleId) {
                _iosParameters.appStoreId?.let { appStoreId = it }
                _iosParameters.customScheme?.let { customScheme = it }
                _iosParameters.fallbackUrl?.let { setFallbackUrl(Uri.parse(it)) }
                _iosParameters.ipadBundleId?.let { ipadBundleId = it }
                _iosParameters.ipadFallbackUrl?.let { ipadFallbackUrl = Uri.parse(it) }
                _iosParameters.minimumVersion?.let { minimumVersion = it }
            }

            val packageName = _androidParameters.packageName
            if (packageName != null) {
                androidParameters(packageName) {
                    _androidParameters.fallbackUrl?.let { fallbackUrl = Uri.parse(it) }
                    _androidParameters.minimumVersion?.let { minimumVersion = it }
                }
            } else {
                androidParameters {
                    _androidParameters.fallbackUrl?.let { fallbackUrl = Uri.parse(it) }
                    _androidParameters.minimumVersion?.let { minimumVersion = it }
                }
            }

            googleAnalyticsParameters {
                _googleAnalyticsParameters.campaign?.let { campaign = it }
                _googleAnalyticsParameters.content?.let { content = it }
                _googleAnalyticsParameters.medium?.let { medium = it }
                _googleAnalyticsParameters.source?.let { source = it }
                _googleAnalyticsParameters.term?.let { term = it }
            }

            itunesConnectAnalyticsParameters {
                _itunesConnectAnalyticsParameters.affiliateToken?.let { affiliateToken = it }
                _itunesConnectAnalyticsParameters.campaignToken?.let { campaignToken = it }
                _itunesConnectAnalyticsParameters.providerToken?.let { providerToken = it }
            }

            navigationInfoParameters {
                forcedRedirectEnabled = _navigationInfoParameters.forcedRedirectEnabled
            }

            socialMetaTagParameters {
                _socialMetaTagParameters.description?.let { description = it }
                _socialMetaTagParameters.imageUrl?.let { imageUrl = Uri.parse(it) }
                _socialMetaTagParameters.title?.let { title = it }
            }
        }

        if (shorten) {
            Firebase.dynamicLinks.shortLinkAsync(_suffix) {
                longLink = dynamicLink.uri
            }.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    if (copyToClipboard) {
                        val act = ctx.activity
                        val cb = act.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                        cb.primaryClip = ClipData.newPlainText("short link",
                                result.shortLink.toString())
                    }

                    dispatchEvent(DynamicLinkEvent.ON_CREATED,
                            gson.toJson(
                                    DynamicLinkEvent(callbackId, true, mapOf(
                                            "previewLink" to result.previewLink.toString(),
                                            "shortLink" to result.shortLink.toString(),
                                            "warnings" to result.warnings.map { it.message }))
                            )
                    )
                } else {
                    val error = task.exception
                    dispatchEvent(DynamicLinkEvent.ON_CREATED, gson.toJson(
                            DynamicLinkEvent(callbackId, true, null, mapOf(
                                    "text" to error?.localizedMessage.toString(),
                                    "id" to 0))
                    ))
                }
            }
        } else {
            if (copyToClipboard) {
                val act = ctx.activity
                val cb = act.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                cb.primaryClip = ClipData.newPlainText("link", dynamicLink.uri.toString())
            }
            dispatchEvent(DynamicLinkEvent.ON_CREATED,
                    gson.toJson(
                            DynamicLinkEvent(callbackId, false, mapOf(
                                    "url" to dynamicLink.uri.toString())
                            )
                    ))
        }
        return null
    }

    fun getDynamicLink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val appActivity = ctx.activity ?: return null
        val task = Firebase.dynamicLinks.getDynamicLink(appActivity.intent)
        task.addOnSuccessListener {
            val link = it?.link ?: ""
            dispatchEvent(DynamicLinkEvent.ON_LINK,
                    gson.toJson(
                            DynamicLinkEvent(callbackId, false, mapOf(
                                    "url" to link.toString()))
                    ))
        }
        task.addOnFailureListener {
            dispatchEvent(DynamicLinkEvent.ON_LINK, gson.toJson(
                    DynamicLinkEvent(callbackId, true, null, mapOf(
                            "text" to it.localizedMessage.toString(),
                            "id" to 0))
            ))
        }
        return null
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