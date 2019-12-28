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
package com.tuarua.firebase.ml.vision.barcode

import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.ml.vision.FirebaseVision
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetector
import com.google.gson.Gson
import com.tuarua.firebase.camerapreview.CameraPreviewFragment
import com.tuarua.firebase.ml.vision.barcode.events.BarcodeEvent
import com.tuarua.firebase.ml.vision.barcode.extensions.FirebaseVisionBarcodeDetectorOptions
import com.tuarua.firebase.ml.vision.barcode.extensions.toFREObject
import com.tuarua.firebase.ml.vision.common.extensions.FirebaseVisionImage
import com.tuarua.frekotlin.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.coroutines.CoroutineContext

// https://www.b4x.com/android/forum/threads/external-library-error-after-upgrade-to-androidx.108607/

// https://github.com/firebase/quickstart-android/blob/master/mlkit/app/src/main/java/com/google/firebase/samples/apps/mlkit/kotlin/automl/AutoMLImageLabelerProcessor.kt

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
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val options = FirebaseVisionBarcodeDetectorOptions(argv[0])
        optionsAsIntArray = IntArray(argv[0]["formats"])
        detector = if (options != null) {
            FirebaseVision.getInstance().getVisionBarcodeDetector(options)
        } else {
            FirebaseVision.getInstance().visionBarcodeDetector
        }
        val appActivity = ctx.activity ?: return true.toFREObject()
        airView = appActivity.findViewById(android.R.id.content) as ViewGroup
        airView = airView.getChildAt(0) as ViewGroup
        return true.toFREObject()
    }

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun detect(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val image = FirebaseVisionImage(argv[0], ctx) ?: return null
        val callbackId = String(argv[1]) ?: return null

        GlobalScope.launch(bgContext) {
            detector.detectInImage(image).addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    val result = task.result ?: return@addOnCompleteListener
                    if (result.isNotEmpty()) {
                        results[callbackId] = result
                        dispatchEvent(BarcodeEvent.DETECTED,
                                gson.toJson(BarcodeEvent(callbackId)))
                    }
                } else {
                    val error = task.exception
                    dispatchEvent(BarcodeEvent.DETECTED,
                            gson.toJson(
                                    BarcodeEvent(callbackId, mapOf(
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

    override fun onVisionProcessSucceed(callbackId: String, result: MutableList<FirebaseVisionBarcode>) {
        results[callbackId] = result
        hideCameraOverlay()
        dispatchEvent(BarcodeEvent.DETECTED, gson.toJson(BarcodeEvent(callbackId)))
    }

    fun inputFromCamera(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val appActivity = ctx.activity ?: return null

        cameraPreviewContainer = FrameLayout(appActivity)
        val frame = cameraPreviewContainer ?: return null
        frame.layoutParams = FrameLayout.LayoutParams(airView.width, airView.height)

        val newId = View.generateViewId()
        frame.id = newId
        airView.addView(frame)

        val optionsAsIntArray = this.optionsAsIntArray
        cameraFragment = CameraPreviewFragment.newInstance(callbackId, optionsAsIntArray)
        val fragmentTransaction = ctx.activity.fragmentManager.beginTransaction()
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