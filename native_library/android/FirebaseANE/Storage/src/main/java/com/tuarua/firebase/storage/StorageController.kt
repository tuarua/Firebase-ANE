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

import android.net.Uri
import android.util.Base64
import android.util.Log
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
import com.google.firebase.storage.*
import com.google.gson.Gson
import com.tuarua.firebase.storage.events.StorageErrorEvent
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.firebase.storage.events.StorageEvent
import com.tuarua.firebase.storage.events.StorageProgressEvent
import java.io.File


@Suppress("UNCHECKED_CAST")
class StorageController(override var context: FREContext?, url: String?) : FreKotlinController {
    private lateinit var storage: FirebaseStorage
    private var listeners: MutableList<Pair<String, String>> = mutableListOf()
    private var uploadTasks: MutableMap<String, UploadTask> = mutableMapOf()
    private var downloadTasks: MutableMap<String, FileDownloadTask> = mutableMapOf()
    private val gson = Gson()

    init {
        try {
            val app = FirebaseApp.getInstance()
            if (app != null) {
                storage = when (url) {
                    null -> FirebaseStorage.getInstance(app)
                    else -> FirebaseStorage.getInstance(app, url)
                }
            } else {
                trace(">>>>>>>>>>NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
            }
        } catch (e: FreException) {
            trace(e.message)
            trace(e.stackTrace)
        } catch (e: Exception) {
            Log.e(TAG, e.message)
            e.printStackTrace()
        }
    }


    fun getReference(path: String?, url: String?): StorageReference? {
        var storageRef: StorageReference? = null
        when {
            path == null && url == null -> storageRef = storage.reference
            path != null -> storageRef = storage.getReference(path)
            url != null -> storageRef = storage.getReferenceFromUrl(url)
        }
        return storageRef

    }

    fun updateMetadata(path: String, asId: String?, metadata: StorageMetadata) {
        val storageRef: StorageReference = storage.getReference(path)
        storageRef.updateMetadata(metadata).addOnCompleteListener { task ->
            if (asId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                sendEvent(StorageEvent.UPDATE_METADATA, gson.toJson(StorageEvent(asId, null)))
            } else {
                val error = task.exception as StorageException
                sendEvent(StorageEvent.UPDATE_METADATA,
                        gson.toJson(
                                StorageEvent(asId, null, mapOf(
                                        "text" to error.message.toString(),
                                        "id" to error.errorCode))
                        )
                )
            }
        }
    }

    fun getMetadata(path: String, asId: String) {
        val storageRef: StorageReference = storage.getReference(path)
        storageRef.metadata.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val meta = task.result
                val cmd: MutableMap<String, String> = mutableMapOf()
                meta.customMetadataKeys.forEach { customMetadataKey ->
                    cmd[customMetadataKey] = meta.getCustomMetadata(customMetadataKey)
                }
                sendEvent(StorageEvent.GET_METADATA, gson.toJson(StorageEvent(asId, mapOf("data" to
                        mapOf("bucket" to meta.bucket
                                , "cacheControl" to meta.cacheControl
                                , "contentDisposition" to meta.contentDisposition
                                , "contentEncoding" to meta.contentEncoding
                                , "contentLanguage" to meta.contentLanguage
                                , "contentType" to meta.contentType
                                , "creationTime" to meta.creationTimeMillis
                                , "updatedTime" to meta.updatedTimeMillis
                                , "generation" to meta.generation
                                , "md5Hash" to meta.md5Hash
                                , "metadataGeneration" to meta.metadataGeneration
                                , "name" to meta.name
                                , "path" to meta.path
                                , "size" to meta.sizeBytes
                                , "customMetadata" to cmd
                        )))))
            } else {
                val error = task.exception as StorageException
                sendEvent(StorageEvent.GET_METADATA,
                        gson.toJson(
                                StorageEvent(asId, null, mapOf(
                                        "text" to error.message.toString(),
                                        "id" to error.errorCode))
                        )
                )

            }
        }

    }

    fun getParent(path: String): StorageReference? {
        return storage.getReference(path).parent
    }

    fun getRoot(path: String): StorageReference? {
        return storage.getReference(path).root
    }

    fun deleteReference(path: String, asId: String?) {
        storage.getReference(path).delete().addOnCompleteListener { task ->
            if (asId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                sendEvent(StorageEvent.DELETED,
                        gson.toJson(StorageEvent(asId, mapOf("localPath" to path))))
            } else {
                val error = task.exception as StorageException
                sendEvent(StorageEvent.DELETED,
                        gson.toJson(
                                StorageEvent(asId, null, mapOf(
                                        "text" to error.message.toString(),
                                        "id" to error.errorCode))
                        )
                )
            }
        }
    }

    fun getFile(path: String, destinationFile: String, asId: String) {
        val storageRef = storage.getReference(path)
        val file = File(destinationFile)

        downloadTasks[asId] = storageRef.getFile(file)
        downloadTasks[asId]?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, StorageEvent.TASK_COMPLETE)) return@addOnCompleteListener
                sendEvent(StorageEvent.TASK_COMPLETE,
                        gson.toJson(StorageEvent(asId, mapOf("localPath" to destinationFile))))
            } else {
                if (!hasEventListener(asId, StorageErrorEvent.ERROR)) return@addOnCompleteListener
                val error = task.exception as StorageException
                sendEvent(StorageErrorEvent.ERROR,
                        gson.toJson(StorageErrorEvent(asId, error.message, error.errorCode)))
            }

        }?.addOnProgressListener { taskSnapshot ->
            if (!hasEventListener(asId, StorageProgressEvent.PROGRESS)) return@addOnProgressListener
            if (taskSnapshot.totalByteCount > 0 && taskSnapshot.bytesTransferred > 0) {
                sendEvent(StorageProgressEvent.PROGRESS,
                        gson.toJson(StorageProgressEvent(asId,
                                taskSnapshot.bytesTransferred,
                                taskSnapshot.totalByteCount))
                )
            }
        }

    }

    fun getBytes(path: String, maxDownloadSizeBytes: Long?, asId: String) {
        val storageRef = storage.getReference(path)
        val ONE_MEGABYTE: Long = 1024 * 1024
        val _maxDownloadSizeBytes: Long = if (maxDownloadSizeBytes is Long && maxDownloadSizeBytes > 0) {
            maxDownloadSizeBytes
        } else ONE_MEGABYTE

        storageRef.getBytes(_maxDownloadSizeBytes).addOnSuccessListener { bytes ->
            if (!hasEventListener(asId, StorageEvent.TASK_COMPLETE)) return@addOnSuccessListener
            val b64 = Base64.encodeToString(bytes, Base64.NO_WRAP)
            sendEvent(StorageEvent.TASK_COMPLETE, gson.toJson(StorageEvent(asId, mapOf("b64" to b64))))

        }.addOnFailureListener { exception ->
            if (!hasEventListener(asId, StorageErrorEvent.ERROR)) return@addOnFailureListener
            val error = exception as StorageException
            sendEvent(StorageErrorEvent.ERROR,
                    gson.toJson(StorageErrorEvent(asId, error.message, error.errorCode)))
        }
    }

    fun putBytes(path: String, asId: String, bytes: ByteArray, metadata: StorageMetadata?) {
        val storageRef = storage.getReference(path)
        uploadTasks[asId] = when {
            metadata != null -> storageRef.putBytes(bytes, metadata)
            else -> storageRef.putBytes(bytes)
        }

        uploadTasks[asId]?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, StorageEvent.TASK_COMPLETE)) return@addOnCompleteListener
                sendEvent(StorageEvent.TASK_COMPLETE, gson.toJson(StorageEvent(asId, null)))
            } else {
                if (!hasEventListener(asId, StorageErrorEvent.ERROR)) return@addOnCompleteListener
                val error = task.exception as StorageException
                sendEvent(StorageErrorEvent.ERROR,
                        gson.toJson(StorageErrorEvent(asId, error.message, error.errorCode)))
            }
            uploadTasks.remove(asId)
        }?.addOnProgressListener { taskSnapshot ->
            if (!hasEventListener(asId, StorageProgressEvent.PROGRESS)) return@addOnProgressListener
            if (taskSnapshot.totalByteCount > 0 && taskSnapshot.bytesTransferred > 0) {
                sendEvent(StorageProgressEvent.PROGRESS, gson.toJson(
                        StorageProgressEvent(asId,
                                taskSnapshot.bytesTransferred,
                                taskSnapshot.totalByteCount))
                )
            }
        }
    }

    fun putFile(path: String, asId: String, filePath: String, metadata: StorageMetadata?) {
        val storageRef = storage.getReference(path)
        val uri = Uri.fromFile(File(filePath))
        uploadTasks[asId] = when {
            metadata != null -> storageRef.putFile(uri, metadata)
            else -> storageRef.putFile(uri)
        }

        uploadTasks[asId]?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, StorageEvent.TASK_COMPLETE)) return@addOnCompleteListener
                sendEvent(StorageEvent.TASK_COMPLETE,
                        gson.toJson(StorageEvent(asId, mapOf("localPath" to filePath))))
            } else {
                if (!hasEventListener(asId, StorageErrorEvent.ERROR)) return@addOnCompleteListener
                val error = task.exception as StorageException
                sendEvent(StorageErrorEvent.ERROR,
                        gson.toJson(StorageErrorEvent(asId, error.message, error.errorCode)))
            }
            uploadTasks.remove(asId)
        }?.addOnProgressListener { taskSnapshot ->
            if (!hasEventListener(asId, StorageProgressEvent.PROGRESS)) return@addOnProgressListener
            if (taskSnapshot.totalByteCount > 0 && taskSnapshot.bytesTransferred > 0) {
                sendEvent(StorageProgressEvent.PROGRESS, gson.toJson(
                        StorageProgressEvent(asId,
                                taskSnapshot.bytesTransferred,
                                taskSnapshot.totalByteCount))
                )
            }
        }

    }

    fun pauseTask(asId: String) {
        uploadTasks[asId]?.pause()
        downloadTasks[asId]?.pause()
    }

    fun resumeTask(asId: String) {
        uploadTasks[asId]?.resume()
        downloadTasks[asId]?.resume()
    }

    fun cancelTask(asId: String) {
        uploadTasks[asId]?.cancel()
        downloadTasks[asId]?.cancel()
    }

    fun getDownloadUrl(path: String, asId: String) {
        val storageRef = storage.getReference(path)
        storageRef.downloadUrl.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val url: String = task.result.toString()
                sendEvent(StorageEvent.GET_DOWNLOAD_URL,
                        gson.toJson(StorageEvent(asId, mapOf("url" to url))))
            } else {
                val error = task.exception as StorageException
                sendEvent(StorageEvent.GET_DOWNLOAD_URL,
                        gson.toJson(
                                StorageEvent(asId, null, mapOf(
                                        "text" to error.message.toString(),
                                        "id" to error.errorCode))
                        )
                )
            }
        }
    }

    fun getMaxDownloadRetryTime(): Long = storage.maxDownloadRetryTimeMillis
    fun getMaxUploadRetryTime(): Long = storage.maxUploadRetryTimeMillis
    fun getMaxOperationRetryTime(): Long = storage.maxOperationRetryTimeMillis
    fun setMaxDownloadRetryTime(value: Long) {
        storage.maxDownloadRetryTimeMillis = value
    }

    fun setMaxUploadRetryTime(value: Long) {
        storage.maxOperationRetryTimeMillis = value
    }

    fun setMaxOperationRetryTime(value: Long) {
        storage.maxUploadRetryTimeMillis = value
    }

    /**************** Listeners ****************/
    fun addEventListener(asId: String, type: String) {
        listeners.add(Pair(asId, type))
    }

    fun removeEventListener(asId: String, type: String) {
        for (i in listeners.indices) {
            if (listeners[i].first == asId && listeners[i].second == type) {
                listeners.removeAt(i)
                return
            }
        }
    }

    private fun hasEventListener(asId: String, type: String): Boolean {
        for (i in listeners.indices) {
            if (listeners[i].first == asId && listeners[i].second == type) {
                return true
            }
        }
        return false
    }

    override val TAG: String
        get() = this::class.java.simpleName

}