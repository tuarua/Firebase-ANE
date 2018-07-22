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
package com.tuarua.firebase.dynamiclinks.extensions

import com.adobe.fre.FREObject
import com.google.firebase.dynamiclinks.DynamicLink
import com.google.firebase.dynamiclinks.DynamicLink.ItunesConnectAnalyticsParameters.Builder
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
fun ItunesConnectAnalyticsParameters(freObject: FREObject?): DynamicLink.ItunesConnectAnalyticsParameters? {
    val rv = freObject ?: return null
    val affiliateToken = String(rv["affiliateToken"])
    val campaignToken = String(rv["campaignToken"])
    val providerToken = String(rv["providerToken"])
    val builder = Builder()
    if (affiliateToken != null) builder.setAffiliateToken(affiliateToken)
    if (campaignToken != null) builder.setCampaignToken(campaignToken)
    if (providerToken != null) builder.setProviderToken(providerToken)
    return builder.build()
}