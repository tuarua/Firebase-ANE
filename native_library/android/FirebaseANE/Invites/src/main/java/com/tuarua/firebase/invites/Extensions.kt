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

@file:Suppress("FunctionName", "unused")

package com.tuarua.firebase.invites

import android.net.Uri
import com.adobe.fre.FREObject
import com.google.firebase.dynamiclinks.DynamicLink.AndroidParameters
import com.google.firebase.dynamiclinks.DynamicLink.GoogleAnalyticsParameters
import com.google.firebase.dynamiclinks.DynamicLink.IosParameters
import com.google.firebase.dynamiclinks.DynamicLink.ItunesConnectAnalyticsParameters
import com.google.firebase.dynamiclinks.DynamicLink.SocialMetaTagParameters
import com.google.firebase.dynamiclinks.DynamicLink.NavigationInfoParameters
import com.tuarua.frekotlin.Int
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.Boolean
import com.tuarua.frekotlin.get

fun IosParameters(freObject: FREObject?): IosParameters? {
    val rv = freObject ?: return null
    val bundleId = String(rv["bundleId"]) ?: return null
    val appStoreId = String(rv["appStoreId"])
    val customScheme = String(rv["customScheme"])
    val fallbackUrl = String(rv["fallbackUrl"])
    val ipadBundleId = String(rv["ipadBundleId"])
    val ipadFallbackUrl = String(rv["ipadFallbackUrl"])
    val minimumVersion = String(rv["minimumVersion"])

    val builder = IosParameters.Builder(bundleId)
    if (appStoreId != null) builder.setAppStoreId(appStoreId)
    if (customScheme != null) builder.setCustomScheme(customScheme)
    if (fallbackUrl != null) builder.setFallbackUrl(Uri.parse(fallbackUrl))
    if (ipadBundleId != null) builder.setIpadBundleId(ipadBundleId)
    if (ipadFallbackUrl != null) builder.setIpadFallbackUrl(Uri.parse(ipadFallbackUrl))
    if (minimumVersion != null) builder.setMinimumVersion(minimumVersion)
    return builder.build()
}

fun AndroidParameters(freObject: FREObject?): AndroidParameters? {
    val rv = freObject ?: return null
    val packageName = String(rv["packageName"])
    val fallbackUrl = String(rv["fallbackUrl"])
    val minimumVersion = Int(rv["minimumVersion"])
    val builder:AndroidParameters.Builder
    builder = when (packageName) {
        null -> AndroidParameters.Builder()
        else -> AndroidParameters.Builder(packageName)
    }
    if (fallbackUrl != null) builder.setFallbackUrl(Uri.parse(fallbackUrl))
    if (minimumVersion != null) builder.setMinimumVersion(minimumVersion)
    return builder.build()
}

fun GoogleAnalyticsParameters(freObject: FREObject?): GoogleAnalyticsParameters? {
    val rv = freObject ?: return null
    val campaign = String(rv["campaign"])
    val content = String(rv["content"])
    val medium = String(rv["medium"])
    val source = String(rv["source"])
    val term = String(rv["term"])
    val builder = GoogleAnalyticsParameters.Builder()
    if (campaign != null) builder.setCampaign(campaign)
    if (content != null) builder.setContent(content)
    if (medium != null) builder.setMedium(medium)
    if (source != null) builder.setSource(source)
    if (term != null) builder.setTerm(term)
    return builder.build()
}

fun ItunesConnectAnalyticsParameters(freObject: FREObject?): ItunesConnectAnalyticsParameters? {
    val rv = freObject ?: return null
    val affiliateToken = String(rv["affiliateToken"])
    val campaignToken = String(rv["campaignToken"])
    val providerToken = String(rv["providerToken"])
    val builder = ItunesConnectAnalyticsParameters.Builder()
    if (affiliateToken != null) builder.setAffiliateToken(affiliateToken)
    if (campaignToken != null) builder.setCampaignToken(campaignToken)
    if (providerToken != null) builder.setProviderToken(providerToken)
    return builder.build()
}

fun SocialMetaTagParameters(freObject: FREObject?): SocialMetaTagParameters? {
    val rv = freObject ?: return null
    val description = String(rv["description"])
    val imageUrl = String(rv["imageUrl"])
    val title = String(rv["title"])
    val builder = SocialMetaTagParameters.Builder()
    if (description != null) builder.setDescription(description)
    if (imageUrl != null) builder.setImageUrl(Uri.parse(imageUrl))
    if (title != null) builder.setTitle(title)
    return builder.build()
}

fun NavigationInfoParameters(freObject: FREObject?): NavigationInfoParameters? {
    val rv = freObject ?: return null
    val forcedRedirectEnabled = Boolean(rv["forcedRedirectEnabled"]) == true
    val builder = NavigationInfoParameters.Builder()
    builder.setForcedRedirectEnabled(forcedRedirectEnabled)
    return builder.build()
}