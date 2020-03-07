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

package com.tuarua.firebase.storage

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import com.adobe.fre.FREByteArray
import com.tuarua.firebase.storage.extensions.StorageMetadata
import com.tuarua.firebase.storage.extensions.toFREObject
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER")
class KotlinController : FreKotlinMainController {
    private lateinit var storageController: StorageController

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val url = String(argv[0])
        storageController = StorageController(context, url)
        return true.toFREObject()
    }

    fun getReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val url = String(argv[1])
        return storageController.getReference(path, url)?.toFREObject()
    }

    fun getFile(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val destinationFile = String(argv[1]) ?: return null
        val callbackId = String(argv[2]) ?: return null
        storageController.getFile(path, destinationFile, callbackId)
        return null
    }

    fun getParent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        return storageController.getParent(path)?.toFREObject()
    }

    fun getRoot(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        return storageController.getRoot(path)?.toFREObject()
    }

    fun deleteReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        storageController.deleteReference(path, callbackId)
        return null
    }

    fun getBytes(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val maxDownloadSizeBytes = Long(argv[1]) ?: return null
        val callbackId = String(argv[2]) ?: return null
        storageController.getBytes(path, maxDownloadSizeBytes, callbackId)
        return null
    }

    fun putBytes(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        val ba = argv[2] as FREByteArray
        val metadata = StorageMetadata(argv[3])
        try {
            ba.acquire()
            val bb = ba.bytes
            val bytes = ByteArray(ba.length.toInt())
            bb.get(bytes)
            ba.release()
            if (bytes.isNotEmpty()) {
                storageController.putBytes(path, callbackId, bytes, metadata)
            } else {
                return null
            }
        } catch (e: FreException) {
            return e.getError()
        } catch (e: Exception) {
            return FreException(e).getError()
        }
        return null
    }

    fun putFile(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        val filePath = String(argv[2]) ?: return null
        val metadata= StorageMetadata(argv[3])
        storageController.putFile(path, callbackId, filePath, metadata)
        return null
    }

    fun pauseTask(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        storageController.pauseTask(callbackId)
        return null
    }

    fun resumeTask(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        storageController.resumeTask(callbackId)
        return null
    }

    fun cancelTask(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        storageController.cancelTask(callbackId)
        return null
    }

    fun getDownloadUrl(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        storageController.getDownloadUrl(path, callbackId)
        return null
    }

    fun getMetadata(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val callbackId = String(argv[1]) ?: return null
        storageController.getMetadata(path, callbackId)
        return null
    }

    fun updateMetadata(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException()
        val path = String(argv[0]) ?: return null
        val callbackId = String(argv[1])
        val metadata = StorageMetadata(argv[2]) ?: return null
        storageController.updateMetadata(path, callbackId, metadata)
        return null
    }

    fun getMaxDownloadRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        return storageController.getMaxDownloadRetryTime().toFREObject()
    }

    fun getMaxUploadRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        return storageController.getMaxUploadRetryTime().toFREObject()
    }

    fun getMaxOperationRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        return storageController.getMaxOperationRetryTime().toFREObject()
    }

    fun setMaxDownloadRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = Long(argv[0]) ?: return null
        storageController.setMaxDownloadRetryTime(value)
        return null
    }

    fun setMaxUploadRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = Long(argv[0]) ?: return null
        storageController.setMaxUploadRetryTime(value)
        return null
    }

    fun setMaxOperationRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException()
        val value = Long(argv[0]) ?: return null
        storageController.setMaxOperationRetryTime(value)
        return null
    }

    /**************** Listeners ****************/

    fun addEventListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val type = String(argv[1]) ?: return null
        storageController.addEventListener(callbackId, type)
        return null
    }

    fun removeEventListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException()
        val callbackId = String(argv[0]) ?: return null
        val type = String(argv[1]) ?: return null
        storageController.removeEventListener(callbackId, type)
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
