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

import android.app.Fragment
import android.graphics.Point
import android.graphics.Rect
import android.os.Bundle
import android.support.annotation.IdRes
import android.util.Log
import android.util.Size
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode
import com.tuarua.firebase.ml.vision.barcode.KotlinController
import com.tuarua.firebase.ml.scanner.BarcodeVisionProcessor
import com.tuarua.firebase.ml.scanner.FrameVisionProcessor
import com.tuarua.firebase.ml.scanner.VisionProcessListener
import com.tuarua.firebase.view.widget.AutoFitTextureView
import com.tuarua.firebase.visionbarcodeane.R

private const val ARG_EVENTID = "eventId"
private const val ARG_FORMATS = "formats"

class CameraPreviewFragment : Fragment(), CameraPreviewManager.OnCameraPreviewCallback,
        VisionProcessListener, CameraPreviewManager.OnDisplaySizeRequireHandler,
        FrameVisionProcessor.CameraInformationCollector {

    private var eventId: String? = null
    private var formats: IntArray? = null
    private var listener: BarcodeProcessSucceedListener? = null

    private val cameraView: AutoFitTextureView by bindView(R.id.activity_camera_preview_mainview)
    private lateinit var cameraPreviewManager: CameraPreviewManager
    private lateinit var frameVisionProcessor: FrameVisionProcessor
    private var found: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            eventId = it.getString(ARG_EVENTID)
            formats = it.getIntArray(ARG_FORMATS)
        }
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.activity_camera_preview, container, false)
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.d("CameraPreviewFragment", "onDestroy")
        frameVisionProcessor.release()
    }

    override fun onPause() {
        super.onPause()
        Log.d("CameraPreviewFragment", "onPause")
        cameraPreviewManager.release()
    }

    override fun onResume() {
        super.onResume()
        Log.d("CameraPreviewFragment", "onResume")
        cameraPreviewManager.start()
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        cameraPreviewManager = CameraPreviewManager(view.context, cameraView, this, this)
        cameraPreviewManager.start()

        val formats = formats ?: intArrayOf(65535)

        val barcodeVisionProcessor = BarcodeVisionProcessor(formats).also {
            it.visionProcessListener = this
        }

        frameVisionProcessor = FrameVisionProcessor(barcodeVisionProcessor, this)

        readyToShowCameraView()

    }

    private fun readyToShowCameraView() {
        Log.d("CameraPreviewFragment", "readyToShowCameraView")
        cameraView.visibility = View.VISIBLE
        frameVisionProcessor.start()
    }

    override fun onDetach() {
        super.onDetach()
        listener = null
    }

    override fun getDisplaySize(point: Point) = activity.windowManager.defaultDisplay.getSize(point)
    override fun getDisplayOrientation(): Int = activity.windowManager.defaultDisplay.rotation

    override fun getCameraPreviewSize(): Size = cameraPreviewManager.previewSize ?: Size(1280, 720)

    override fun getPreviewCroppedRect(): Rect = cameraPreviewManager.cropRect
            ?: Rect(0, 0, 1280, 720)

    override fun getCameraOrientation(): Int = cameraPreviewManager.rotationConstraintDigit

    override fun getCameraFacingDirection(): Int = cameraPreviewManager.facing ?: 0


    override fun onByteArrayGenerated(bytes: ByteArray?) {
        bytes?.run {
            frameVisionProcessor.setNextFrame(this)
        }
    }

    override fun onVisionProcessSucceed(result: MutableList<FirebaseVisionBarcode>) {
        if (found) return
        found = true
        val eventId = eventId ?: return
        listener?.onVisionProcessSucceed(eventId, result)
        close()
    }

    override fun shouldRequestPermission() {}

    override fun onError(message: String) {
        cameraView.visibility = View.GONE
    }

    interface BarcodeProcessSucceedListener {
        fun onVisionProcessSucceed(eventId: String, result: MutableList<FirebaseVisionBarcode>)
    }

    private fun <T : View> Fragment.bindView(@IdRes id: Int): Lazy<T> =
            lazy { view.findViewById<T>(id) }

    fun setListener(kotlinController: KotlinController) {
        listener = kotlinController
    }

    fun close() {
        if (activity != null && activity.fragmentManager != null) {
            activity.fragmentManager.beginTransaction().remove(this).commit()
        }
    }

//    fun toggleFlashlight(enabled: Boolean) {
//        cameraPreviewManager.toggleFlashlight(enabled)
//    }

    companion object {
        @JvmStatic
        fun newInstance(eventId: String, formats: IntArray?) =
                CameraPreviewFragment().apply {
                    arguments = Bundle().apply {
                        putString(ARG_EVENTID, eventId)
                        putIntArray(ARG_FORMATS, formats)
                    }
                }
    }
}
