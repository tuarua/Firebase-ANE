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
import android.content.Context
import android.graphics.*
import android.hardware.camera2.*
import android.media.Image
import android.media.ImageReader
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import android.os.Message
import android.util.Log
import android.util.Size
import android.view.Surface
import android.view.TextureView
import com.tuarua.firebase.view.widget.AutoFitTextureView

import java.util.concurrent.Semaphore
import java.util.concurrent.TimeUnit
import kotlin.math.sign


/**
 * Camera initializing processing is
 *  - Init surfaceView / TextureView. should make sure [SurfaceView] or [TextureView] is initialized.
 *  - Check **Camera Permission**. In this phase, it needs a callback to
 *  main Activity. Otherwise, Activity can't display camera previewing if not permitted.
 *  - If camera permission is grant. Run the background thread for camera things.
 *  - Make sure background thread and surfaceView is all Ready. Init Camera.
 *  - After camera initialization. Put Preview on the screen.
 *
 *  - Additional info if use TextureView
 *    - in [TextureView] it needs to handle rotation and image matrix ourselves.
 *    - needs to get orientation of the device and the camera sensor
 *    - check [setupCameraParams(cameraManager: CameraManager)] and [configureTransform()] methods for more infos.
 */
@SuppressLint("MissingPermission")
class CameraPreviewManager(private val context: Context, private val textureView: AutoFitTextureView,
                           private val cameraCallback: OnCameraPreviewCallback,
                           private val displaySizeRequireHandler: OnDisplaySizeRequireHandler) {
    enum class CameraState {
        CLOSED,
        OPENED,
        PREVIEW
    }

    var facing: Int? = null
    /**
     * such as 0 degree = 0, 90 degree = 1, 180 degree = 2, 270 degree = 3
     */
    var rotationConstraintDigit: Int = 0
        get() {
            return field / 90
        }

    private var uiHandler: UIHandler? = null
    private var backgroundThread: HandlerThread? = null

    private val cameraStateLock = Object()
    // needs to be protected
    private var backgroundHandler: Handler? = null
    private var imageReader: ImageReader? = null
    private var cameraCaptureSession: CameraCaptureSession? = null
    private var cameraId: String? = null
    private var cameraCharacteristics: CameraCharacteristics? = null
    private var camera: CameraDevice? = null
    private val cameraOpenCloseLock: Semaphore = Semaphore(1)
    var cameraState = CameraState.CLOSED
    var previewSize: Size? = null
        get() {
            synchronized(cameraStateLock) {
                return field
            }
        }
    var cropRect: Rect? = null
        get() {
            synchronized(cameraStateLock) {
                return field
            }
        }

    private var isAborted: Boolean = false
    private val imageBufferCounts = 2
    private val aspectRatioTolerance = 0.005

    private val orientationMap = mapOf(
            Pair(Surface.ROTATION_0, 0),
            Pair(Surface.ROTATION_90, 90),
            Pair(Surface.ROTATION_180, 180),
            Pair(Surface.ROTATION_270, 270)
    )

    fun release() {
        if (isAborted) {
            return
        }

        try {
            cameraOpenCloseLock.acquire()
            synchronized(cameraStateLock) {
                cameraState = CameraState.CLOSED
                cameraCaptureSession?.close()
                cameraCaptureSession = null
                camera?.close()
                camera = null
                imageReader?.close()
                imageReader = null
            }
            stopThread()
        } catch (e: InterruptedException) {
            Log.e("CameraPreviewManager", Log.getStackTraceString(e))
        } finally {
            cameraOpenCloseLock.release()
        }
    }

    private fun initCamera() {
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        if (!setupCameraParams(cameraManager)) {
            cameraCallback.onError("Opening Camera is failed. Please try again.")
            return
        }

        if (!cameraOpenCloseLock.tryAcquire(2500, TimeUnit.MILLISECONDS)) {
            cameraCallback.onError("Opening Camera is timeout. Please try again.")
        }

        var cameraId: String? = null
        var backgroundHandler: Handler? = null
        synchronized(cameraStateLock) {
            cameraId = this.cameraId
            backgroundHandler = this.backgroundHandler
        }
        // https://medium.com/@ssaurel/create-a-torch-flashlight-application-for-android-c0b6951855c
        // cameraManager.setTorchMode()
        cameraManager.openCamera(cameraId, cameraDeviceCallback(), backgroundHandler)
    }

    private fun setupCameraParams(cameraManager: CameraManager): Boolean {
        for (cameraId in cameraManager.cameraIdList) {
            val characteristic = cameraManager.getCameraCharacteristics(cameraId)

            // Ignore Front Facing Camera
            val facing = characteristic.get(CameraCharacteristics.LENS_FACING)
            if (facing == CameraCharacteristics.LENS_FACING_FRONT) {
                continue
            }

            synchronized(cameraStateLock) {
                this.cameraCharacteristics = characteristic
                this.cameraId = cameraId
                this.facing = facing
            }
            return true
        }

        return false
    }

    private fun configureTransform(width: Int, height: Int) {
        requireNotNull(cameraCharacteristics)
        if (!textureView.isAvailable) {
            return
        }

        synchronized(cameraStateLock) {
            cameraCharacteristics?.run {
                val map = get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP)

                val largestSize = map.getOutputSizes(ImageFormat.JPEG).maxWith(CompareAreaSize())

                // find the rotation of the device relative to the native device orientation
                val deviceOrientation = displaySizeRequireHandler.getDisplayOrientation()
                val displaySize = Point()
                displaySizeRequireHandler.getDisplaySize(displaySize)

                // find the rotation of the device relative to the camera sensor
                val totalRotation = sensorToDeviceRotation(deviceOrientation)
                rotationConstraintDigit = totalRotation

                // swap the dimension if needed
                val swappedDimension = totalRotation == 90 || totalRotation == 270
                val rotatedViewWidth = if (swappedDimension) height else width
                val rotatedViewHeight = if (swappedDimension) width else height

                // preview should not be larger than display size and 1080p
                val maxPreviewWidth = swappedDimension.let { shouldSwap ->
                    var result = if (shouldSwap) displaySize.y else displaySize.x
                    if (result > 1920) result = 1920
                    result
                }
                val maxPreviewHeight = swappedDimension.let { shouldSwap ->
                    var result = if (shouldSwap) displaySize.x else displaySize.y
                    if (result > 1080) result = 1080
                    result
                }

                // find best preview size for these view dimensions and configured JPEG size
                val previewSize = largestSize?.let {
                    chooseOptimalSize(map.getOutputSizes(SurfaceTexture::class.java),
                            rotatedViewWidth, rotatedViewHeight, maxPreviewWidth, maxPreviewHeight,
                            it)
                }

                val w = previewSize?.width ?: 1280
                val h = previewSize?.height ?: 720
                val shortest = if (w < h) w else h
                val scaled: Int = (shortest * 0.75).toInt()
                val cropRect = Rect(0, 0,w, h)
                cropRect.inset((w - scaled) / 2, (h - scaled) / 2)

                previewSize?.run {

                    if (swappedDimension) {
                        textureView.setAspectRatio(this.height, this.width)
                    } else {
                        textureView.setAspectRatio(this.width, this.height)
                    }

                    // find rotation of device in degrees
                    val rotation = (360 - orientationMap[deviceOrientation]!!) % 360

                    val matrix = Matrix()
                    val viewRect = RectF(0f, 0f, width.toFloat(), height.toFloat())
                    val centerX = viewRect.centerX()
                    val centerY = viewRect.centerY()

                    if (deviceOrientation == Surface.ROTATION_90 || deviceOrientation == Surface.ROTATION_270) {
                        val bufferRect = RectF(0f, 0f, this.height.toFloat(), this.width.toFloat())
                        bufferRect.offset(centerX - bufferRect.centerX(), centerY - bufferRect.centerY())
                        matrix.setRectToRect(viewRect, bufferRect, Matrix.ScaleToFit.FILL)
                        val scale = Math.max(
                                height.toFloat() / this.height,
                                width.toFloat() / this.width
                        )
                        matrix.postScale(scale, scale, centerX, centerY)
                    }
                    matrix.postRotate(rotation.toFloat(), centerX, centerY)
                    textureView.setTransform(matrix)

                    if (this@CameraPreviewManager.previewSize == null || !checkAspectsEqual(previewSize, this@CameraPreviewManager.previewSize!!)) {
                        this@CameraPreviewManager.previewSize = previewSize
                        this@CameraPreviewManager.cropRect = cropRect
                        if (cameraState != CameraState.CLOSED) {
                            if (imageReader == null) {
                                setupImageReader()
                            }

                            startPreviewing()
                        }
                    }
                }
            } ?: return
        }
    }

    /***
     *  Only call this method with [cameraStateLock] held
     */
    private fun setupImageReader() {
        previewSize?.run {
            // IMPORTANT:: green frames means the resolution or the camera settings are not supported.
            // choose the right resolution/settings and it will display normally.
            imageReader = ImageReader.newInstance(width, height, ImageFormat.YUV_420_888, imageBufferCounts)
            imageReader?.setOnImageAvailableListener({ reader ->
                backgroundHandler?.post {
                    if (cameraState != CameraState.CLOSED) {
                        val image = reader?.acquireLatestImage() ?: return@post
                        // IMPORTANT::new Camera2 Api which sends YUV_420_888 yuv format
                        // instead of NV21 (YUV_420_SP) format. And MLKit needs NV21 format
                        // so it needs to convert
                        if (cropRect != null) {
                            image.cropRect = cropRect
                        }
                        val bytes = image.convertYUV420888ToNV21()

                        cameraCallback.onByteArrayGenerated(bytes)
                        image.close()
                    }
                }
            }, backgroundHandler)
        }
    }

    private fun checkAspectsEqual(firstSize: Size, secondSize: Size): Boolean {
        val firstAspect = firstSize.width / firstSize.height.toDouble()
        val secondAspect = secondSize.width / secondSize.height.toDouble()
        return Math.abs(firstAspect - secondAspect) <= aspectRatioTolerance
    }

    private fun sensorToDeviceRotation(deviceOrientationRaw: Int): Int {
        return cameraCharacteristics?.let {
            val sensorOrientation = it.get(CameraCharacteristics.SENSOR_ORIENTATION)
            val deviceOrientation = orientationMap[deviceOrientationRaw] ?: 0
            (sensorOrientation - deviceOrientation + 360) % 360
        } ?: -1
    }

    private inner class CompareAreaSize : Comparator<Size> {
        override fun compare(first: Size, second: Size): Int {
            // use Long ensure multiplication won't overflow
            val firstAreaSize = first.width.toLong() * first.height
            val secondAreaSize = second.width.toLong() * second.height
            return (firstAreaSize - secondAreaSize).sign
        }
    }

    private fun chooseOptimalSize(sizes: Array<Size>, textureViewWidth: Int,
                                  textureViewHeight: Int, maxWidth: Int, maxHeight: Int,
                                  aspectRatio: Size): Size? {

        // The supported resolution that are at least as big as the preview surface
        val bigEnoughSizes = mutableListOf<Size>()
        // The supported resolution that are smaller than the preview Surface
        val notBigEnoughSizes = mutableListOf<Size>()

        val width = aspectRatio.width
        val height = aspectRatio.height
        for (size in sizes) {
            if (size.width <= maxWidth && size.height <= maxHeight &&
                    size.height == size.width * height / width) {

                if (size.width >= textureViewWidth && size.height >= textureViewHeight) {
                    bigEnoughSizes.add(size)
                } else {
                    notBigEnoughSizes.add(size)
                }
            }
        }

        // Pick the smallest sizes in these big enough sizes. If there is no big enough size,
        // pick the largest sizes in the NOT big enough sizes.
        if (bigEnoughSizes.isNotEmpty()) {
            return bigEnoughSizes.minWith(CompareAreaSize())
        }

        if (notBigEnoughSizes.isNotEmpty()) {
            return notBigEnoughSizes.maxWith(CompareAreaSize())
        }
        // No proper size
        return sizes[0]
    }

    private fun cameraDeviceCallback(): CameraDevice.StateCallback = object : CameraDevice.StateCallback() {
        override fun onOpened(cameraDevice: CameraDevice?) {
            synchronized(cameraStateLock) {
                cameraState = CameraState.OPENED
                cameraOpenCloseLock.release()
                camera = cameraDevice

                if (previewSize != null && textureView.isAvailable) {
                    if (imageReader == null) {
                        setupImageReader()
                    }

                    startPreviewing()
                }
            }
        }

        override fun onDisconnected(cameraDevice: CameraDevice?) {
            synchronized(cameraStateLock) {
                cameraState = CameraState.CLOSED
                cameraOpenCloseLock.release()
                cameraDevice?.close()
                camera = null
            }
        }

        override fun onError(cameraDevice: CameraDevice?, error: Int) {
            synchronized(cameraStateLock) {
                cameraState = CameraState.CLOSED
                cameraOpenCloseLock.release()
                cameraDevice?.close()
                camera = null
            }

            cameraCallback.onError("Opening Camera is failed. Please try again.")
        }
    }

    /**
     * Only call this method with [cameraStateLock] held
     */
    private fun startPreviewing() {
        // TextureView surface
        val surfaceTexture = textureView.surfaceTexture ?: return
        surfaceTexture.setDefaultBufferSize(previewSize?.width ?: 1280, previewSize?.height ?: 720)
        val surface = Surface(surfaceTexture)

        // ImageReader surface
        val imageReaderSurface = imageReader?.surface

        val captureRequestBuilder = camera?.createCaptureRequest(CameraDevice.TEMPLATE_PREVIEW)
        captureRequestBuilder?.addTarget(surface)
        captureRequestBuilder?.addTarget(imageReaderSurface)

        camera?.createCaptureSession(listOf(surface, imageReaderSurface), object : CameraCaptureSession.StateCallback() {
            override fun onConfigured(cameraCaptureSession: CameraCaptureSession?) {
                synchronized(cameraStateLock) {
                    if (camera == null) {
                        return
                    }
                    this@CameraPreviewManager.cameraCaptureSession = cameraCaptureSession

                    captureRequestBuilder?.set(CaptureRequest.CONTROL_AF_MODE, CaptureRequest.CONTROL_AF_MODE_CONTINUOUS_PICTURE)
                    val previewRequest = captureRequestBuilder?.build()
                    cameraCaptureSession?.setRepeatingRequest(previewRequest, null, backgroundHandler)

                    cameraState = CameraState.PREVIEW
                }
            }

            override fun onConfigureFailed(captureSession: CameraCaptureSession?) {
                uiHandler?.obtainMessage(UIHandler.sendMessage, "Opening Camera is failed. Please try again.")?.sendToTarget()
            }
        }, backgroundHandler)
    }

    private fun startThread() {
        backgroundThread = HandlerThread("CameraBackground")
        backgroundThread?.start()
        uiHandler = UIHandler(cameraCallback)

        synchronized(cameraStateLock) {
            backgroundHandler = Handler(backgroundThread?.looper)
        }
    }

    private fun stopThread() {
        backgroundThread?.quitSafely()
        backgroundThread?.join()
        backgroundThread = null
        uiHandler = null

        synchronized(cameraStateLock) {
            backgroundHandler = null
        }
    }

    // Credit
    // https://www.polarxiong.com/archives/Android-YUV_420_888编码Image转换为I420和NV21格式byte数组.html
    private fun Image.convertYUV420888ToNV21(): ByteArray {
        val crop = this.cropRect
        val width = crop.width()
        val height = crop.height()
        val planes = this.planes
        val data = ByteArray(width * height * ImageFormat.getBitsPerPixel(this.format) / 8)
        val rowData = ByteArray(planes[0].rowStride)
        var channelOffset = 0
        var outputStride = 1
        for (i in planes.indices) {
            when (i) {
                0 -> {
                    channelOffset = 0
                    outputStride = 1
                }
                1 -> {
                    channelOffset = width * height + 1
                    outputStride = 2
                }
                2 -> {
                    channelOffset = width * height
                    outputStride = 2
                }
            }
            val buffer = planes[i].buffer
            val rowStride = planes[i].rowStride
            val pixelStride = planes[i].pixelStride
            val shift = if (i == 0) 0 else 1
            val w = width shr shift
            val h = height shr shift
            buffer.position(rowStride * (crop.top shr shift) + pixelStride * (crop.left shr shift))
            for (row in 0 until h) {
                val length: Int
                if (pixelStride == 1 && outputStride == 1) {
                    length = w
                    buffer.get(data, channelOffset, length)
                    channelOffset += length
                } else {
                    length = (w - 1) * pixelStride + 1
                    buffer.get(rowData, 0, length)
                    for (col in 0 until w) {
                        data[channelOffset] = rowData[col * pixelStride]
                        channelOffset += outputStride
                    }
                }
                if (row < h - 1) {
                    buffer.position(buffer.position() + rowStride - length)
                }
            }
        }
        return data
    }

    fun start() {
        startThread()
        initCamera()
        if (textureView.isAvailable) {
            configureTransform(textureView.width, textureView.height)
        } else {
            textureView.surfaceTextureListener = SurfaceTextureCallback()
        }
    }

    inner class SurfaceTextureCallback : TextureView.SurfaceTextureListener {
        override fun onSurfaceTextureUpdated(p0: SurfaceTexture?) {
        }

        override fun onSurfaceTextureSizeChanged(surfaceTexture: SurfaceTexture?, width: Int, height: Int) {
            configureTransform(width, height)
        }

        override fun onSurfaceTextureDestroyed(p0: SurfaceTexture?): Boolean {
            synchronized(cameraStateLock) {
                previewSize = null
                cropRect = null
            }
            return true
        }

        override fun onSurfaceTextureAvailable(surfaceTexture: SurfaceTexture?, width: Int, height: Int) {
            configureTransform(width, height)
        }
    }

    class UIHandler(failureCallback: OnCameraPreviewCallback) : Handler(Looper.getMainLooper()) {
        companion object {
            const val sendMessage: Int = 1001
        }

        private var failedCallback: OnCameraPreviewCallback = failureCallback

        override fun handleMessage(message: Message?) {
            when (message?.what) {
                sendMessage -> {
                    val errorMessage: String = message.obj as String
                    failedCallback.onError(errorMessage)
                }
                else -> super.handleMessage(message)
            }
        }
    }

    interface OnCameraPreviewCallback {
        fun shouldRequestPermission()
        fun onError(message: String)
        fun onByteArrayGenerated(bytes: ByteArray?)
    }

    interface OnDisplaySizeRequireHandler {
        fun getDisplaySize(point: Point)
        fun getDisplayOrientation(): Int
    }
}