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
import com.google.firebase.ktx.Firebase
import com.google.firebase.ktx.app
import com.google.firebase.storage.ktx.storage
import com.google.firebase.storage.*
import com.google.gson.Gson
import com.tuarua.firebase.storage.events.StorageErrorEvent
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.FreKotlinController
import com.tuarua.firebase.storage.events.StorageEvent
import com.tuarua.firebase.storage.events.StorageProgressEvent
import com.tuarua.firebase.storage.extensions.toMap
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
            val app = Firebase.app
            storage = when (url) {
                null -> Firebase.storage(app)
                else -> Firebase.storage(app, url)
            }
        } catch (e: FreException) {
            warning(e.message)
            warning(e.stackTrace)
        } catch (e: Exception) {
            warning(e.message)
            warning(Log.getStackTraceString(e))
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

    fun updateMetadata(path: String, callbackId: String?, metadata: StorageMetadata) {
        val storageRef: StorageReference = storage.getReference(path)
        storageRef.updateMetadata(metadata).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(StorageEvent.UPDATE_METADATA, gson.toJson(StorageEvent(callbackId, null)))
            } else {
                val error = task.exception as StorageException
                dispatchEvent(StorageEvent.UPDATE_METADATA,
                        gson.toJson(StorageEvent(callbackId, error = error.toMap()))
                )
            }
        }
    }

    fun getMetadata(path: String, callbackId: String) {
        val storageRef: StorageReference = storage.getReference(path)
        storageRef.metadata.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val meta = task.result ?: return@addOnCompleteListener
                dispatchEvent(StorageEvent.GET_METADATA, gson.toJson(StorageEvent(callbackId, mapOf("data" to meta.toMap()))))
            } else {
                val error = task.exception as StorageException
                dispatchEvent(StorageEvent.GET_METADATA,
                        gson.toJson(StorageEvent(callbackId, error = error.toMap()))
                )
            }
        }
    }

    fun getParent(path: String): StorageReference? = storage.getReference(path).parent
    fun getRoot(path: String): StorageReference? = storage.getReference(path).root

    fun deleteReference(path: String, callbackId: String?) {
        storage.getReference(path).delete().addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(StorageEvent.DELETED,
                        gson.toJson(StorageEvent(callbackId, mapOf("localPath" to path))))
            } else {
                val error = task.exception as StorageException
                dispatchEvent(StorageEvent.DELETED,
                        gson.toJson(StorageEvent(callbackId, error = error.toMap()))
                )
            }
        }
    }

    fun getFile(path: String, destinationFile: String, callbackId: String) {
        val storageRef = storage.getReference(path)
        val file = File(destinationFile)

        downloadTasks[callbackId] = storageRef.getFile(file)
        downloadTasks[callbackId]?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(callbackId, StorageEvent.TASK_COMPLETE)) return@addOnCompleteListener
                dispatchEvent(StorageEvent.TASK_COMPLETE,
                        gson.toJson(StorageEvent(callbackId, mapOf("localPath" to destinationFile))))
            } else {
                if (!hasEventListener(callbackId, StorageErrorEvent.ERROR)) return@addOnCompleteListener
                val error = task.exception as StorageException
                dispatchEvent(StorageErrorEvent.ERROR,
                        gson.toJson(StorageErrorEvent(callbackId, error.message, error.errorCode)))
            }

        }?.addOnProgressListener { taskSnapshot ->
            if (!hasEventListener(callbackId, StorageProgressEvent.PROGRESS)) return@addOnProgressListener
            if (taskSnapshot.totalByteCount > 0 && taskSnapshot.bytesTransferred > 0) {
                dispatchEvent(StorageProgressEvent.PROGRESS,
                        gson.toJson(StorageProgressEvent(callbackId,
                                taskSnapshot.bytesTransferred,
                                taskSnapshot.totalByteCount))
                )
            }
        }

    }

    fun getBytes(path: String, maxDownloadSizeBytes: Long?, callbackId: String) {
        val storageRef = storage.getReference(path)
        val ONE_MEGABYTE: Long = 1024 * 1024
        val _maxDownloadSizeBytes: Long = if (maxDownloadSizeBytes is Long && maxDownloadSizeBytes > 0) {
            maxDownloadSizeBytes
        } else ONE_MEGABYTE

        storageRef.getBytes(_maxDownloadSizeBytes).addOnSuccessListener { bytes ->
            if (!hasEventListener(callbackId, StorageEvent.TASK_COMPLETE)) return@addOnSuccessListener
            val b64 = Base64.encodeToString(bytes, Base64.NO_WRAP)
            dispatchEvent(StorageEvent.TASK_COMPLETE, gson.toJson(StorageEvent(callbackId, mapOf("b64" to b64))))

        }.addOnFailureListener { exception ->
            if (!hasEventListener(callbackId, StorageErrorEvent.ERROR)) return@addOnFailureListener
            val error = exception as StorageException
            dispatchEvent(StorageErrorEvent.ERROR,
                    gson.toJson(StorageErrorEvent(callbackId, error.message, error.errorCode)))
        }
    }

    fun putBytes(path: String, callbackId: String, bytes: ByteArray, metadata: StorageMetadata?) {
        val storageRef = storage.getReference(path)
        uploadTasks[callbackId] = when {
            metadata != null -> storageRef.putBytes(bytes, metadata)
            else -> storageRef.putBytes(bytes)
        }

        uploadTasks[callbackId]?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(callbackId, StorageEvent.TASK_COMPLETE)) return@addOnCompleteListener
                dispatchEvent(StorageEvent.TASK_COMPLETE, gson.toJson(StorageEvent(callbackId, null)))
            } else {
                if (!hasEventListener(callbackId, StorageErrorEvent.ERROR)) return@addOnCompleteListener
                val error = task.exception as StorageException
                dispatchEvent(StorageErrorEvent.ERROR,
                        gson.toJson(StorageErrorEvent(callbackId, error.message, error.errorCode)))
            }
            uploadTasks.remove(callbackId)
        }?.addOnProgressListener { taskSnapshot ->
            if (!hasEventListener(callbackId, StorageProgressEvent.PROGRESS)) return@addOnProgressListener
            if (taskSnapshot.totalByteCount > 0 && taskSnapshot.bytesTransferred > 0) {
                dispatchEvent(StorageProgressEvent.PROGRESS, gson.toJson(
                        StorageProgressEvent(callbackId,
                                taskSnapshot.bytesTransferred,
                                taskSnapshot.totalByteCount))
                )
            }
        }
    }

    fun putFile(path: String, callbackId: String, filePath: String, metadata: StorageMetadata?) {
        val storageRef = storage.getReference(path)
        val uri = Uri.fromFile(File(filePath))
        uploadTasks[callbackId] = when {
            metadata != null -> storageRef.putFile(uri, metadata)
            else -> storageRef.putFile(uri)
        }

        uploadTasks[callbackId]?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(callbackId, StorageEvent.TASK_COMPLETE)) return@addOnCompleteListener
                dispatchEvent(StorageEvent.TASK_COMPLETE,
                        gson.toJson(StorageEvent(callbackId, mapOf("localPath" to filePath))))
            } else {
                if (!hasEventListener(callbackId, StorageErrorEvent.ERROR)) return@addOnCompleteListener
                val error = task.exception as StorageException
                dispatchEvent(StorageErrorEvent.ERROR,
                        gson.toJson(StorageErrorEvent(callbackId, error.message, error.errorCode)))
            }
            uploadTasks.remove(callbackId)
        }?.addOnProgressListener { taskSnapshot ->
            if (!hasEventListener(callbackId, StorageProgressEvent.PROGRESS)) return@addOnProgressListener
            if (taskSnapshot.totalByteCount > 0 && taskSnapshot.bytesTransferred > 0) {
                dispatchEvent(StorageProgressEvent.PROGRESS, gson.toJson(
                        StorageProgressEvent(callbackId,
                                taskSnapshot.bytesTransferred,
                                taskSnapshot.totalByteCount))
                )
            }
        }

    }

    fun pauseTask(callbackId: String) {
        uploadTasks[callbackId]?.pause()
        downloadTasks[callbackId]?.pause()
    }

    fun resumeTask(callbackId: String) {
        uploadTasks[callbackId]?.resume()
        downloadTasks[callbackId]?.resume()
    }

    fun cancelTask(callbackId: String) {
        uploadTasks[callbackId]?.cancel()
        downloadTasks[callbackId]?.cancel()
    }

    fun getDownloadUrl(path: String, callbackId: String) {
        val storageRef = storage.getReference(path)
        storageRef.downloadUrl.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val url: String = task.result.toString()
                dispatchEvent(StorageEvent.GET_DOWNLOAD_URL,
                        gson.toJson(StorageEvent(callbackId, mapOf("url" to url))))
            } else {
                val error = task.exception as StorageException
                dispatchEvent(StorageEvent.GET_DOWNLOAD_URL,
                        gson.toJson(StorageEvent(callbackId, error = error.toMap()))
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
    fun addEventListener(callbackId: String, type: String) {
        listeners.add(Pair(callbackId, type))
    }

    fun removeEventListener(callbackId: String, type: String) {
        for (i in listeners.indices) {
            if (listeners[i].first == callbackId && listeners[i].second == type) {
                listeners.removeAt(i)
                return
            }
        }
    }

    private fun hasEventListener(callbackId: String, type: String): Boolean {
        for (i in listeners.indices) {
            if (listeners[i].first == callbackId && listeners[i].second == type) {
                return true
            }
        }
        return false
    }

    override val TAG: String
        get() = this::class.java.simpleName

}