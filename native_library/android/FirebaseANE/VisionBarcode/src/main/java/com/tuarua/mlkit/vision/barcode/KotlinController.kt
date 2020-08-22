/*
 * Copyright 2020 Tua Rua Ltd.
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
package com.tuarua.mlkit.vision.barcode

import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.gson.Gson
import com.google.mlkit.vision.barcode.BarcodeScanner
import com.google.mlkit.vision.barcode.Barcode
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.tuarua.mlkit.vision.camerapreview.CameraPreviewFragment
import com.tuarua.mlkit.vision.barcode.events.BarcodeEvent
import com.tuarua.mlkit.vision.barcode.extensions.BarcodeScannerOptions
import com.tuarua.mlkit.vision.barcode.extensions.toFREObject
import com.tuarua.mlkit.vision.extensions.InputImage

import com.tuarua.frekotlin.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.util.*
import kotlin.coroutines.CoroutineContext

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController, CameraPreviewFragment.BarcodeProcessSucceedListener {
    private lateinit var airView: ViewGroup
    private var optionsAsIntArray: IntArray? = null
    private var results: MutableMap<String, MutableList<Barcode>> = mutableMapOf()
    private val gson = Gson()
    private val bgContext: CoroutineContext = Dispatchers.Default
    private val scanningBarcodeRequestCode = 1002
    private lateinit var detector: BarcodeScanner
    private lateinit var cameraFragment: CameraPreviewFragment
    private var cameraPreviewContainer: FrameLayout? = null

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val options = BarcodeScannerOptions(argv[0])
        optionsAsIntArray = IntArray(argv[0]["formats"])

        detector = if (options != null) {
            BarcodeScanning.getClient(options)
        } else {
            BarcodeScanning.getClient()
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
        val image = InputImage(argv[0], ctx) ?: return null
        val callbackId = String(argv[1]) ?: return null

        GlobalScope.launch(bgContext) {
            detector.process(image).addOnCompleteListener { task ->
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

    override fun onVisionProcessSucceed(callbackId: String, result: MutableList<Barcode>) {
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