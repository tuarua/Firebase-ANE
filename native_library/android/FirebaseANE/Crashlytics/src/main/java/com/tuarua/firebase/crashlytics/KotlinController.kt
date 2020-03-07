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

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import java.util.*
import com.crashlytics.android.Crashlytics
import io.fabric.sdk.android.Fabric
import io.fabric.sdk.android.Fabric.Builder
import android.content.Intent


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val debug = Boolean(argv[0]) == true
        try {
            val fabric = Builder(ctx.activity.applicationContext).kits(Crashlytics()).debuggable(debug).build()
            Fabric.with(fabric)
        } catch (e: Exception) {
            return FreException(e).getError()
        }
        return true.toFREObject()
    }

    fun crash(ctx: FREContext, argv: FREArgv): FREObject? {
        val act = context?.activity ?: return null
        act.startActivity(Intent(act, CrashlyticsActivity::class.java))
        return null
    }

    fun log(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val message = String(argv[0]) ?: return null
        Crashlytics.log(message)
        return null
    }

    fun logException(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val message = String(argv[0])
        val exception = Exception(message)
        Crashlytics.logException(exception)
        return null
    }

    fun setUserIdentifier(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = String(argv[0]) ?: return null
        Crashlytics.setUserIdentifier(value)
        return null
    }

    fun setUserEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = String(argv[0]) ?: return null
        Crashlytics.setUserEmail(value)
        return null
    }

    fun setUserName(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = String(argv[0]) ?: return null
        Crashlytics.setUserName(value)
        return null
    }

    fun setString(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val value = String(argv[1]) ?: return null
        Crashlytics.setString(key, value)
        return null
    }

    fun setBool(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val value = Boolean(argv[1]) ?: return null
        Crashlytics.setBool(key, value)
        return null
    }

    fun setDouble(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val value = Double(argv[1]) ?: return null
        Crashlytics.setDouble(key, value)
        return null
    }

    fun setInt(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val key = String(argv[0]) ?: return null
        val value = Int(argv[1]) ?: return null
        Crashlytics.setInt(key, value)
        return null
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