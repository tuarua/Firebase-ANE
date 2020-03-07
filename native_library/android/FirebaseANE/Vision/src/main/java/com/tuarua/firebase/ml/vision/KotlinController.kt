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
package com.tuarua.firebase.ml.vision

import android.Manifest
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.core.content.ContextCompat
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.gson.Gson
import com.tuarua.firebase.ml.vision.events.PermissionEvent
import com.tuarua.frekotlin.*
import com.tuarua.frenative.FreNativeButton
import com.tuarua.frenative.FreNativeImage
import com.tuarua.frenative.FreNativeType
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val permissionsNeeded: Array<String> = arrayOf(
            Manifest.permission.CAMERA)
    private val gson = Gson()
    private var packageManager: PackageManager? = null
    private var packageInfo: PackageInfo? = null
    private var permissionsGranted = false


    private var userChildren: MutableMap<String, Any> = mutableMapOf()
    private lateinit var cameraOverlayContainer: CameraOverlayContainer
    private lateinit var airView: ViewGroup
    private var cameraOverlayContainerAdded: Boolean = false

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        val appActivity = ctx.activity ?: return false.toFREObject()
        airView = appActivity.findViewById(android.R.id.content) as ViewGroup
        airView = airView.getChildAt(0) as ViewGroup
        cameraOverlayContainer = CameraOverlayContainer(ctx.activity)
        cameraOverlayContainer.layoutParams = FrameLayout.LayoutParams(airView.width, airView.height)
        cameraOverlayContainer.visibility = View.INVISIBLE

        packageManager = appActivity.packageManager
        val pm = packageManager ?: return false.toFREObject()
        packageInfo = pm.getPackageInfo(appActivity.packageName, PackageManager.GET_PERMISSIONS)
        EventBus.getDefault().register(this)
        return hasRequiredPermissions().toFREObject()
    }

    private fun hasRequiredPermissions(): Boolean {
        val pi = packageInfo ?: return false
        permissionsNeeded.forEach { p ->
            if (p !in pi.requestedPermissions) {
                warning("Please add $p to uses-permission list in your AIR manifest")
                return false
            }
        }
        return true
    }

    fun requestPermissions(ctx: FREContext, argv: FREArgv): FREObject? {
        try {
            val permissionsToCheck = getPermissionsToCheck()
            if (permissionsToCheck.size == 0 || Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
                dispatchEvent(PermissionEvent.ON_PERMISSION_STATUS,
                        gson.toJson(
                                PermissionEvent(Manifest.permission.ACCESS_FINE_LOCATION,
                                        PermissionEvent.PERMISSION_ALWAYS)
                        ))
                permissionsGranted = true
                return null
            }
            val permissionIntent = Intent(ctx.activity.applicationContext, PermissionActivity::class.java)
            permissionIntent.putExtra("ptc", permissionsToCheck.toTypedArray())
            ctx.activity.startActivity(permissionIntent)
        } catch (e: Exception) {
            return FreException(e).getError()
        }
        return null
    }

    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: PermissionEvent) {
        dispatchEvent(PermissionEvent.ON_PERMISSION_STATUS, gson.toJson(event))
        when (event.status) {
            PermissionEvent.PERMISSION_ALWAYS -> permissionsGranted = true
        }
    }

    private fun getPermissionsToCheck(): ArrayList<String> {
        val appCtx = context?.activity?.applicationContext ?: return ArrayList()
        val pi = packageInfo ?: return ArrayList()
        val permissionsToCheck = ArrayList<String>()
        pi.requestedPermissions.filterTo(permissionsToCheck) {
            it in permissionsNeeded &&
                    ContextCompat.checkSelfPermission(appCtx, it) != PackageManager.PERMISSION_GRANTED
        }
        return permissionsToCheck
    }

    fun isCameraSupported(ctx: FREContext, argv: FREArgv): FREObject? {
        return (Build.VERSION.SDK_INT >= 21).toFREObject()
    }

    fun addNativeChild(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return null
        val child = argv[0]
        val id = String(child["id"]) ?: return null
        val type = Int(child["type"]) ?: return null
        val scaleFactor = Float(argv[1]) ?: return null
        if (!cameraOverlayContainerAdded) {
            airView.addView(cameraOverlayContainer)
            cameraOverlayContainerAdded = true
        }

        when (FreNativeType.fromInt(type)) {
            FreNativeType.IMAGE -> {
                if (userChildren.containsKey(id)) {
                    cameraOverlayContainer.addView(userChildren[id] as FreNativeImage)
                } else {
                    val nativeImage = FreNativeImage(ctx.activity.applicationContext, child, scaleFactor)
                    cameraOverlayContainer.addView(nativeImage)
                    userChildren[id] = nativeImage
                }
            }
            FreNativeType.BUTTON -> {
                if (userChildren.containsKey(id)) {
                    cameraOverlayContainer.addView(userChildren[id] as FreNativeButton)
                } else {
                    val nativeButton = FreNativeButton(ctx.activity.applicationContext, ctx, child, id, scaleFactor)
                    cameraOverlayContainer.addView(nativeButton)
                    userChildren[id] = nativeButton
                }
            }
        }
        return null
    }

    fun updateNativeChild(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 && userChildren.isNotEmpty() } ?: return null
        val id = String(argv[0]) ?: return null
        val propName = argv[1]
        val propVal = argv[2]

        userChildren[id]?.let {
            if (it is FreNativeImage) {
                it.update(propName, propVal)
            } else if (it is FreNativeButton) {
                it.update(propName, propVal)
            }
        }
        return null
    }

    fun removeNativeChild(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return null
        val id = String(argv[0]) ?: return null
        userChildren[id]?.let {
            if (it is FreNativeImage) {
                cameraOverlayContainer.removeView(it)
            } else if (it is FreNativeButton) {
                cameraOverlayContainer.removeView(it)
            }
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
