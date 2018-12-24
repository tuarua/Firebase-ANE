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

package com.tuarua.firebase.mlscanner

import android.graphics.Rect
import android.util.Size

class FrameVisionProcessor(private val visionImageProcessor: VisionImageProcessor,
                           private val cameraInformationCollector: CameraInformationCollector) {
    private val processingRunnable = FrameProcessingRunnable()
    private var processingThread: Thread? = Thread(processingRunnable)
    private val processorLock = Object()    // for synchronization use

    fun start() {
        val isFirstStart = processingThread?.state == Thread.State.NEW
        if (isFirstStart) {
            processingThread?.start()
            processingRunnable.active = true
        }
    }

    fun setNextFrame(bytes: ByteArray) {
        processingRunnable.data = bytes
    }

    fun release() {
        synchronized(processorLock) {
            stop()
            visionImageProcessor.stop()
        }
    }

    private fun stop() {
        processingRunnable.active = false
        processingThread = processingThread?.let {
            it.join()
            null
        }
    }

    private inner class FrameProcessingRunnable : Runnable {
        private val dataLock = Object()    // synchronization use

        internal var active = false
            set(value) {
                synchronized(dataLock) {
                    field = value
                    dataLock.notifyAll()
                }
            }

        internal var data: ByteArray? = null
            set(value) {
                synchronized(dataLock) {
                    field = value
                    dataLock.notifyAll()
                }
            }

        override fun run() {
            var bytes: ByteArray? = null
            while (true) {
                synchronized(dataLock) {
                    while (active && data == null) {
                        try {
                            dataLock.wait()
                        } catch (e: InterruptedException) {
                            return
                        }
                    }

                    if (!active) {
                        return
                    }

                    bytes = data
                    data = null    // clean up
                }

                synchronized(processorLock) {
                    bytes?.run {
                        val frameMetaData = FrameMetadata(
                                cameraInformationCollector.getPreviewCroppedRect().width(),
                                cameraInformationCollector.getPreviewCroppedRect().height(),
                                cameraInformationCollector.getCameraOrientation(),
                                cameraInformationCollector.getCameraFacingDirection()
                        )
                        visionImageProcessor.process(this, frameMetaData)
                    }
                }
            }
        }
    }

    interface CameraInformationCollector {
        fun getCameraPreviewSize(): Size
        fun getPreviewCroppedRect(): Rect
        fun getCameraOrientation(): Int
        fun getCameraFacingDirection(): Int
    }
}