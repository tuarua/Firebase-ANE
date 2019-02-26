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
package com.tuarua.firebase.vision.barcode

import android.app.FragmentTransaction
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.tuarua.firebase.vision.barcode.extensions.*
import com.tuarua.firebase.vision.extensions.FirebaseVisionImage
import com.tuarua.frekotlin.*
import java.util.*
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetector
import com.google.gson.Gson
import com.tuarua.firebase.camerapreview.CameraPreviewFragment
import com.tuarua.firebase.vision.barcode.events.BarcodeEvent

import kotlin.coroutines.CoroutineContext
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController, CameraPreviewFragment.BarcodeProcessSucceedListener {
    private lateinit var airView: ViewGroup
    private var optionsAsIntArray: IntArray? = null
    private var results: MutableMap<String, MutableList<FirebaseVisionBarcode>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private val scanningBarcodeRequestCode = 1002
    private lateinit var detector: FirebaseVisionBarcodeDetector
    private lateinit var cameraFragment: CameraPreviewFragment
    private var cameraPreviewContainer: FrameLayout? = null

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        val options = FirebaseVisionBarcodeDetectorOptions(argv[0])
        optionsAsIntArray = IntArray(argv[0]["formats"])
        detector = if (options != null) {
            FirebaseVision.getInstance().getVisionBarcodeDetector(options)
        } else {
            FirebaseVision.getInstance().visionBarcodeDetector
        }
        val appActivity = ctx.activity
        if (appActivity != null) {
            airView = appActivity.findViewById(android.R.id.content) as ViewGroup
            airView = airView.getChildAt(0) as ViewGroup
        }

        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("detect")
        val image = FirebaseVisionImage(argv[0], ctx) ?: return null
        val eventId = String(argv[1]) ?: return null

        GlobalScope.launch(bgContext) {
            detector.detectInImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    if (!task.result.isEmpty()) {
                        results[eventId] = task.result
                        dispatchEvent(BarcodeEvent.DETECTED,
                                gson.toJson(BarcodeEvent(eventId)))
                    }
                } else {
                    val error = task.exception
                    dispatchEvent(BarcodeEvent.DETECTED,
                            gson.toJson(
                                    BarcodeEvent(eventId, mapOf(
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
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getResults")
        val eventId = String(argv[0]) ?: return null
        val result = results[eventId] ?: return null
        val ret = result.toFREArray()
        results.remove(eventId)
        return ret
    }

    override fun onVisionProcessSucceed(eventId: String, result: MutableList<FirebaseVisionBarcode>) {
        results[eventId] = result
        hideCameraOverlay()
        dispatchEvent(BarcodeEvent.DETECTED, gson.toJson(BarcodeEvent(eventId)))
    }

    fun inputFromCamera(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("inputFromCamera")
        val eventId = String(argv[0]) ?: return null
        val appActivity = ctx.activity ?: return null

        cameraPreviewContainer = FrameLayout(appActivity)
        val frame = cameraPreviewContainer ?: return null
        frame.layoutParams = FrameLayout.LayoutParams(airView.width, airView.height)

        val newId = View.generateViewId()
        frame.id = newId
        airView.addView(frame)

        val optionsAsIntArray = this.optionsAsIntArray
        cameraFragment = CameraPreviewFragment.newInstance(eventId, optionsAsIntArray)
        val fragmentTransaction: FragmentTransaction = ctx.activity.fragmentManager.beginTransaction()
        fragmentTransaction.add(newId, cameraFragment)
        fragmentTransaction.commit()
        cameraFragment.setListener(this)

        showCameraOverlay()

        return null
    }

    fun closeCamera(ctx: FREContext, argv: FREArgv): FREObject? {
        detector.close()
        cameraFragment.close()
        hideCameraOverlay()
        val frame = cameraPreviewContainer ?: return null
        airView.removeView(frame)
        return null
    }

//    fun hasFlashlight(ctx: FREContext, argv: FREArgv): FREObject? {
//        return (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M
//                && ctx.activity.applicationContext.packageManager
//                .hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH)).toFREObject()
//    }
//
//    fun toggleFlashlight(ctx: FREContext, argv: FREArgv): FREObject? {
//        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return null
//        argv.takeIf { argv.size > 0 } ?: return FreArgException("toggleFlashlight")
//        val enabled = Boolean(argv[0]) ?: return null
//        cameraFragment.toggleFlashlight(enabled)
//        return null
//    }

    private fun hideCameraOverlay() {
        val childCount = airView.childCount
        for (i in 0 until childCount) {
            val child = airView.getChildAt(i)
            if (child.javaClass.simpleName != "CameraOverlayContainer") continue
            child.visibility = View.INVISIBLE
            return
        }
    }

    private fun showCameraOverlay() {
        val childCount = airView.childCount
        for (i in 0 until childCount) {
            val child = airView.getChildAt(i)
            if (child.javaClass.simpleName != "CameraOverlayContainer") continue
            child.visibility = View.VISIBLE
            child.bringToFront()
            return
        }
    }

    fun close(ctx: FREContext, argv: FREArgv): FREObject? {
        detector.close()
        return null
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }

}