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
package com.tuarua.firebase.performance

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.PackageManager.GET_PERMISSIONS
import android.view.ViewGroup
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import com.google.firebase.perf.FirebasePerformance
import com.google.firebase.perf.metrics.Trace


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private var traces: MutableMap<String, Trace> = HashMap()
    private var packageManager: PackageManager? = null
    private var packageInfo: PackageInfo? = null
    private val permissionsNeeded: Array<String> = arrayOf(
            "com.google.android.providers.gsf.permission.READ_GSERVICES",
            "com.google.android.providers.gsf.permission.WRITE_GSERVICES")
    private lateinit var airView: ViewGroup
    private fun hasRequiredPermissions(): Boolean {
        val pi = packageInfo ?: return false
        permissionsNeeded.forEach { p ->
            if (p !in pi.requestedPermissions) {
                trace("Please add $p to uses-permission list in your AIR manifest")
                return false
            }
        }
        return true
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        val isDataCollectionEnabled = Boolean(argv[0]) == true
        val appActivity = ctx.activity
        if (appActivity != null) {
            airView = appActivity.findViewById(android.R.id.content) as ViewGroup
            airView = airView.getChildAt(0) as ViewGroup
            packageManager = appActivity.packageManager
            val pm = packageManager ?: return false.toFREObject()
            packageInfo = pm.getPackageInfo(appActivity.packageName, GET_PERMISSIONS)
            FirebasePerformance.getInstance().isPerformanceCollectionEnabled = isDataCollectionEnabled
            return hasRequiredPermissions().toFREObject()
        }
        return false.toFREObject()
    }

    fun startTrace(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("startTrace")
        val name = String(argv[0]) ?: return FreConversionException("name")
        if (traces[name] == null) {
            traces[name] = FirebasePerformance.getInstance().newTrace(name)
        }
        traces[name]?.start()
        return null
    }

    fun stopTrace(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("stopTrace")
        val name = String(argv[0]) ?: return FreConversionException("name")
        traces[name]?.stop()
        return null
    }

    fun incrementCounter(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("incrementCounter")
        val name = String(argv[0]) ?: return FreConversionException("name")
        val counterName = String(argv[1]) ?: return FreConversionException("name")
        val by = Long(argv[2]) ?: return FreConversionException("by")
        traces[name]?.incrementCounter(counterName, by)
        return null
    }

    fun setIsDataCollectionEnabled(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("setIsDataCollectionEnabled")
        val value = Boolean(argv[0]) ?: return FreConversionException("value")
        FirebasePerformance.getInstance().isPerformanceCollectionEnabled = value
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