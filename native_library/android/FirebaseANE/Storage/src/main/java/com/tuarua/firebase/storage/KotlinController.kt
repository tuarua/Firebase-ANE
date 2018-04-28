package com.tuarua.firebase.storage

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import com.adobe.fre.FREByteArray
import java.util.*


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var storageController: StorageController

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        val url = String(argv[0])
        storageController = StorageController(context, url)
        return true.toFREObject()
    }

    fun getReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("getReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val url = String(argv[1])
        return storageController.getReference(path, url)?.toFREObject()
    }

    fun getFile(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("getReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val destinationFile = String(argv[1]) ?: return FreConversionException("destinationFile")
        val asId = String(argv[2]) ?: return FreConversionException("asId")
        storageController.getFile(path, destinationFile, asId)
        return null
    }

    fun getParent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return storageController.getParent(path)?.toFREObject()
    }

    fun getRoot(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return storageController.getRoot(path)?.toFREObject()
    }

    fun deleteReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("deleteReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        storageController.deleteReference(path, asId)
        return null
    }

    fun getBytes(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("getBytes")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val maxDownloadSizeBytes = Long(argv[1]) ?: return FreConversionException("path")
        val asId = String(argv[2]) ?: return FreConversionException("asId")
        storageController.getBytes(path, maxDownloadSizeBytes, asId)
        return null
    }

    fun putBytes(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException("putBytes")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        val ba = argv[2] as FREByteArray
        val metadata = StorageMetadata(argv[3])
        try {
            ba.acquire()
            val bb = ba.bytes
            val bytes = ByteArray(ba.length.toInt())
            bb.get(bytes)
            ba.release()
            if (bytes.isNotEmpty()) {
                storageController.putBytes(path, asId, bytes, metadata)
            } else {
                return null
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun putFile(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException("putFile")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        val filePath = String(argv[2]) ?: return FreConversionException("filePath")
        val metadata= StorageMetadata(argv[3])
        storageController.putFile(path, asId, filePath, metadata)
        return null
    }

    fun pauseTask(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("pauseTask")
        val asId = String(argv[0]) ?: return FreConversionException("asId")
        storageController.pauseTask(asId)
        return null
    }

    fun resumeTask(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("resumeTask")
        val asId = String(argv[0]) ?: return FreConversionException("asId")
        storageController.resumeTask(asId)
        return null
    }

    fun cancelTask(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("cancelTask")
        val asId = String(argv[0]) ?: return FreConversionException("asId")
        storageController.cancelTask(asId)
        return null
    }

    fun getDownloadUrl(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("getDownloadUrl")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        storageController.getDownloadUrl(path, asId)
        return null
    }

    fun getMetadata(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("getMetadata")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        storageController.getMetadata(path, asId)
        return null
    }

    fun updateMetadata(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("getMetadata")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        val metadata = StorageMetadata(argv[2]) ?: return FreConversionException("metadata")
        storageController.updateMetadata(path, asId, metadata)
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
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setMaxDownloadRetryTime")
        val value = Long(argv[0]) ?: return FreConversionException("value")
        storageController.setMaxDownloadRetryTime(value)
        return null
    }

    fun setMaxUploadRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setMaxUploadRetryTime")
        val value = Long(argv[0]) ?: return FreConversionException("value")
        storageController.setMaxUploadRetryTime(value)
        return null
    }

    fun setMaxOperationRetryTime(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setMaxOperationRetryTime")
        val value = Long(argv[0]) ?: return FreConversionException("value")
        storageController.setMaxOperationRetryTime(value)
        return null
    }

    /**************** Listeners ****************/

    fun addEventListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("addEventListener")
        val asId = String(argv[0]) ?: return FreConversionException("asId")
        val type = String(argv[1]) ?: return FreConversionException("type")
        storageController.addEventListener(asId, type)
        return null
    }

    fun removeEventListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("removeEventListener")
        val asId = String(argv[0]) ?: return FreConversionException("asId")
        val type = String(argv[1]) ?: return FreConversionException("type")
        storageController.removeEventListener(asId, type)
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
