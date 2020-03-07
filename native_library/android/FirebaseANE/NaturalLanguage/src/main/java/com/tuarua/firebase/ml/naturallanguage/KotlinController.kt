/*
 * Copyright 2019 Tua Rua Ltd.
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

package com.tuarua.firebase.ml.naturallanguage

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.naturallanguage.FirebaseNaturalLanguage
import com.google.firebase.ml.naturallanguage.languageid.FirebaseLanguageIdentification
import com.google.firebase.ml.naturallanguage.languageid.IdentifiedLanguage
import com.tuarua.firebase.ml.naturallanguage.events.LanguageEvent
import com.tuarua.firebase.ml.naturallanguage.extensions.FirebaseLanguageIdentificationOptions
import com.tuarua.firebase.ml.naturallanguage.extensions.toFREObject
import com.google.gson.Gson
import com.tuarua.frekotlin.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.coroutines.CoroutineContext

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController {
    private var results: MutableMap<String, String> = mutableMapOf()
    private var resultsMulti: MutableMap<String, MutableList<IdentifiedLanguage>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private lateinit var languageIdentification: FirebaseLanguageIdentification

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val options = FirebaseLanguageIdentificationOptions(argv[0])
        languageIdentification = if (options != null) {
            FirebaseNaturalLanguage.getInstance().getLanguageIdentification(options)
        } else {
            FirebaseNaturalLanguage.getInstance().languageIdentification
        }
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun identifyLanguage(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val text = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        GlobalScope.launch(bgContext) {
            languageIdentification.identifyLanguage(text).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    if (result == "und") return@addOnCompleteListener
                    results[callbackId] = result
                    dispatchEvent(LanguageEvent.RECOGNIZED,
                            gson.toJson(LanguageEvent(callbackId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(LanguageEvent.RECOGNIZED,
                            gson.toJson(
                                    LanguageEvent(callbackId, mapOf(
                                            "text" to error?.message.toString(),
                                            "id" to 0))
                            )
                    )
                }
            }
        }
        return null
    }

    fun identifyPossibleLanguages(ctx: FREContext, argv: FREArgv): FREObject? {
        val text = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        GlobalScope.launch(bgContext) {
            languageIdentification.identifyPossibleLanguages(text).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    if (result.isEmpty()) return@addOnCompleteListener
                    resultsMulti[callbackId] = result
                    dispatchEvent(LanguageEvent.RECOGNIZED_MULTI,
                            gson.toJson(LanguageEvent(callbackId, null)))
                } else {
                    val error = task.exception
                    dispatchEvent(LanguageEvent.RECOGNIZED_MULTI,
                            gson.toJson(
                                    LanguageEvent(callbackId, mapOf(
                                            "text" to error?.message.toString(),
                                            "id" to 0))
                            )
                    )
                }
            }
        }
        return null
    }

    fun getResults(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val result = results[callbackId] ?: return null
        val ret = result.toFREObject()
        results.remove(callbackId)
        return ret
    }

    fun getResultsMulti(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val result = resultsMulti[callbackId] ?: return null
        val ret = result.toFREObject()
        results.remove(callbackId)
        return ret
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        languageIdentification.close()
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