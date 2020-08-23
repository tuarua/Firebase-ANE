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
package com.tuarua.firebase.crashlytics

import android.os.Looper
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.crashlytics.FirebaseCrashlytics
import com.tuarua.frekotlin.*
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val crashlytics = FirebaseCrashlytics.getInstance()

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        crashlytics.setCrashlyticsCollectionEnabled(Boolean(argv[0]) == true)
        return true.toFREObject()
    }

    fun crash(ctx: FREContext, argv: FREArgv): FREObject? {
        val mainThread = Looper.getMainLooper().thread
        val exception = Exception("Test Crash")
        mainThread.uncaughtExceptionHandler.uncaughtException(mainThread, exception)
        return null
    }

    fun log(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val message = String(argv[0]) ?: return null
        crashlytics.log(message)
        return null
    }

    fun recordException(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val message = String(argv[0])
        val exception = Exception(message)
        crashlytics.recordException(exception)
        return null
    }

    fun setUserId(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = String(argv[0]) ?: return null
        crashlytics.setUserId(value)
        return null
    }

    fun setCustomKey(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val value = argv[1]
        when (value.type) {
            FreObjectTypeKotlin.INT -> Int(value)?.let { FirebaseCrashlytics.getInstance().setCustomKey(key, it) }
            FreObjectTypeKotlin.NUMBER -> Double(value)?.let { FirebaseCrashlytics.getInstance().setCustomKey(key, it) }
            FreObjectTypeKotlin.STRING -> String(value)?.let { FirebaseCrashlytics.getInstance().setCustomKey(key, it) }
            FreObjectTypeKotlin.BOOLEAN -> Boolean(value)?.let { FirebaseCrashlytics.getInstance().setCustomKey(key, it) }
            else -> return null
        }
        return null
    }

    fun didCrashOnPreviousExecution(ctx: FREContext, argv: FREArgv): FREObject? {
        return crashlytics.didCrashOnPreviousExecution().toFREObject()
    }

    override val TAG: String?
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = context
        }
}