/*
 * Copyright 2018 Tua Rua Ltd.
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

package com.tuarua.firebase.camerapreview

import android.annotation.SuppressLint
import android.app.Activity
import android.graphics.Point
import android.os.Bundle
import android.support.annotation.IdRes
import android.util.Log
import android.util.Size
import android.view.View
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.tuarua.firebase.mlscanner.BarcodeVisionProcessor
import com.tuarua.firebase.mlscanner.FrameVisionProcessor
import com.tuarua.firebase.mlscanner.VisionProcessListener
import com.tuarua.firebase.view.widget.AutoFitTextureView
import com.tuarua.firebase.vision.barcode.events.RealtimeBarcodeEvent
import com.tuarua.firebase.visionbarcodeane.R
import org.greenrobot.eventbus.EventBus

class CameraPreviewActivity : Activity(), CameraPreviewManager.OnCameraPreviewCallback,
        CameraPreviewManager.OnDisplaySizeRequireHandler, FrameVisionProcessor.CameraInformationCollector,
        VisionProcessListener {

    override fun shouldRequestPermission() {}

    private val cameraView: AutoFitTextureView by bindView(R.id.activity_camera_preview_mainview)
    private lateinit var cameraPreviewManager: CameraPreviewManager
    private lateinit var frameVisionProcessor: FrameVisionProcessor
    private lateinit var eventId: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val decorView = window.decorView
        val uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_FULLSCREEN
        decorView.systemUiVisibility = uiOptions

        val extras = intent.extras
        val formats = extras.getIntArray("formats")
        eventId = extras.getString("eventId")

        setContentView(R.layout.activity_camera_preview)

        cameraPreviewManager = CameraPreviewManager(applicationContext, cameraView, this, this)
        cameraPreviewManager.start()

        val barcodeVisionProcessor = BarcodeVisionProcessor(formats).also {
            it.visionProcessListener = this
        }

        frameVisionProcessor = FrameVisionProcessor(barcodeVisionProcessor, this)

        readyToShowCameraView()
    }

    override fun onError(message: String) {
        Log.e("CameraPreviewActivity", "onError $message")
        cameraView.visibility = View.GONE
    }

    override fun getDisplaySize(point: Point) = windowManager.defaultDisplay.getSize(point)

    override fun getDisplayOrientation(): Int = windowManager.defaultDisplay.rotation

    override fun onByteArrayGenerated(bytes: ByteArray?) {
        bytes?.run {
            frameVisionProcessor.setNextFrame(this)
        }
    }

    @SuppressLint("NewApi")
    override fun getCameraPreviewSize(): Size = cameraPreviewManager.previewSize ?: Size(1280, 720)

    override fun getCameraOrientation(): Int = cameraPreviewManager.rotationConstraintDigit

    override fun getCameraFacingDirection(): Int = cameraPreviewManager.facing ?: 0

    override fun onVisionProcessSucceed(result: MutableList<FirebaseVisionBarcode>) {
        EventBus.getDefault().post(RealtimeBarcodeEvent(eventId, result))
        setResult(Activity.RESULT_OK, intent)
        finish()
    }

    override fun onDestroy() {
        super.onDestroy()
        frameVisionProcessor.release()
    }

    override fun onPause() {
        super.onPause()
        cameraPreviewManager.release()
    }

    override fun onResume() {
        super.onResume()
        cameraPreviewManager.start()
    }

    private fun readyToShowCameraView() {
        cameraView.visibility = View.VISIBLE
        frameVisionProcessor.start()
    }

    private fun <T : View> Activity.bindView(@IdRes id: Int): Lazy<T> =
            lazy { findViewById<T>(id) }
}