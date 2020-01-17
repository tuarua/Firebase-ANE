package com.tuarua.firebase.dynamiclinks.extensions

import com.adobe.fre.FREObject
import com.google.firebase.dynamiclinks.DynamicLink
import com.google.firebase.dynamiclinks.DynamicLink.*
import com.tuarua.frekotlin.String
import com.tuarua.frekotlin.get

@Suppress("FunctionName")
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