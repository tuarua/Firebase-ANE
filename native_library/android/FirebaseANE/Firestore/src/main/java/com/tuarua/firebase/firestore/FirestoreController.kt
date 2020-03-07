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

package com.tuarua.firebase.firestore

import android.util.Log
import com.adobe.fre.FREContext
import com.google.firebase.firestore.*
import com.google.gson.Gson
import com.tuarua.firebase.firestore.data.Order
import com.tuarua.firebase.firestore.data.Where
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.FreKotlinController
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.Query.Direction.*
import com.google.firebase.firestore.DocumentReference
import com.google.firebase.firestore.QuerySnapshot
import com.google.firebase.firestore.WriteBatch
import com.google.firebase.ktx.Firebase
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.app
import com.tuarua.firebase.firestore.events.*
import com.tuarua.firebase.firestore.extensions.*

class FirestoreController(override var context: FREContext?, loggingEnabled: Boolean,
                          settings: FirebaseFirestoreSettings?) : FreKotlinController {
    private lateinit var firestore: FirebaseFirestore
    private var snapshotRegistrations: MutableMap<String, ListenerRegistration> = HashMap()
    private val gson = Gson()
    private var batch: WriteBatch? = null

    init {
        try {
            FirebaseFirestore.setLoggingEnabled(loggingEnabled)
            firestore = Firebase.firestore(Firebase.app)
            if (settings != null) {
                firestore.firestoreSettings = settings
            }
        } catch (e: FreException) {
            warning(e.message)
            warning(e.stackTrace)
        } catch (e: Exception) {
            warning(e.message)
            warning(Log.getStackTraceString(e))
        }
    }

    fun getFirestoreSettings(): FirebaseFirestoreSettings = firestore.firestoreSettings

    /**************** Collections ****************/

    fun initCollectionReference(path: String): String = firestore.collection(path).id

    fun getCollectionParent(path: String): String? = firestore.collection(path).parent?.path

    /**************** Documents ****************/
    fun getDocuments(path: String, callbackId: String, whereList: MutableList<Where>,
                     orderList: MutableList<Order>, startAtList: List<Any>,
                     startAfterList: List<Any>, endAtList: List<Any>,
                     endBeforeList: List<Any>, limitTo: Int) {
        var q: Query = firestore.collection(path)
        for (w in whereList) when (w.operator) {
            "==" -> q = q.whereEqualTo(w.fieldPath, w.value)
            "<" -> q = q.whereLessThan(w.fieldPath, w.value)
            ">" -> q = q.whereGreaterThan(w.fieldPath, w.value)
            ">=" -> q = q.whereGreaterThanOrEqualTo(w.fieldPath, w.value)
            "<=" -> q = q.whereLessThanOrEqualTo(w.fieldPath, w.value)
        }

        orderList.forEach { o -> q = q.orderBy(o.by, if (o.descending) DESCENDING else ASCENDING) }

        if (startAtList.isNotEmpty()) {
            val startAtArr = startAtList.toTypedArray()
            q = q.startAt(*startAtArr)
        }
        if (startAfterList.isNotEmpty()) {
            val startAfterArr = startAfterList.toTypedArray()
            q = q.startAfter(*startAfterArr)
        }
        if (endAtList.isNotEmpty()) {
            val endAtArr = endAtList.toTypedArray()
            q = q.endAt(*endAtArr)
        }
        if (endBeforeList.isNotEmpty()) {
            val endBeforeArr = endBeforeList.toTypedArray()
            q = q.endBefore(*endBeforeArr)
        }
        q = q.limit(limitTo.toLong())

        q.get().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                val qSnapshot: QuerySnapshot = task.result ?: return@addOnCompleteListener
                val docChanges = qSnapshot.documentChanges
                dispatchEvent(DocumentEvent.QUERY_SNAPSHOT, gson.toJson(DocumentEvent(callbackId, data = mapOf(
                        "metadata" to mapOf(
                                "isFromCache" to qSnapshot.metadata.isFromCache,
                                "hasPendingWrites" to qSnapshot.metadata.hasPendingWrites()),
                        "documentChanges" to docChanges.map { it.toMap() },
                        "documents" to qSnapshot.map { it.toMap() })))
                )
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(DocumentEvent.QUERY_SNAPSHOT, gson.toJson(
                        DocumentEvent(callbackId, error = error.toMap()))
                )
            }
        }
    }

    fun initDocumentReference(path: String): String = firestore.document(path).id
    fun documentWithAutoId(path: String): String = firestore.collection(path).document().path

    fun getDocumentReference(path: String, callbackId: String) {
        val docRef: DocumentReference = firestore.document(path)
        docRef.get().addOnCompleteListener { task ->
            val documentSnapshot: DocumentSnapshot = task.result ?: return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(DocumentEvent.SNAPSHOT, gson.toJson(
                        DocumentEvent(callbackId, documentSnapshot.toMap()))
                )
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(DocumentEvent.SNAPSHOT, gson.toJson(
                        DocumentEvent(callbackId, error = error.toMap()))
                )
            }
        }
    }

    fun addSnapshotListenerDocument(path: String, callbackId: String, callbackCallerId: String) {
        val docRef: DocumentReference = firestore.document(path)
        snapshotRegistrations[callbackCallerId] = docRef.addSnapshotListener { documentSnapshot, error ->
            when (error) {
                null -> if (documentSnapshot != null) {
                    dispatchEvent(DocumentEvent.SNAPSHOT, gson.toJson(
                            DocumentEvent(callbackId, documentSnapshot.toMap(), true))
                    )
                }
                else -> {
                    dispatchEvent(DocumentEvent.SNAPSHOT, gson.toJson(
                            DocumentEvent(callbackId, error = error.toMap()))
                    )
                }
            }
        }
    }

    fun removeSnapshotListener(id: String) {
        snapshotRegistrations[id]?.remove()
        snapshotRegistrations.remove(id)
    }

    fun setDocumentReference(path: String, callbackId: String?, documentData: Map<String, Any>, merge: Boolean) {
        val docRef: DocumentReference = firestore.document(path)
        if (merge) docRef.set(documentData, SetOptions.merge()).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(DocumentEvent.SET, gson.toJson(DocumentEvent(callbackId, mapOf("path" to path))))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(DocumentEvent.SET, gson.toJson(
                        DocumentEvent(callbackId, error = error.toMap()))
                )
            }
        } else docRef.set(documentData).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(DocumentEvent.SET, gson.toJson(DocumentEvent(callbackId, mapOf("path" to path))))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(DocumentEvent.SET, gson.toJson(
                        DocumentEvent(callbackId, error = error.toMap()))
                )
            }
        }
    }

    fun updateDocumentReference(path: String, callbackId: String?, documentData: Map<String, Any>) {
        val docRef: DocumentReference = firestore.document(path)
        docRef.update(documentData).addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(DocumentEvent.UPDATED, gson.toJson(
                        DocumentEvent(callbackId, mapOf("path" to path))))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(DocumentEvent.UPDATED, gson.toJson(
                        DocumentEvent(callbackId, mapOf("path" to path), error = error.toMap()))
                )
            }
        }
    }

    fun deleteDocumentReference(path: String, callbackId: String?) {
        val docRef: DocumentReference = firestore.document(path)
        docRef.delete().addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(DocumentEvent.DELETED, gson.toJson(DocumentEvent(callbackId)))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(DocumentEvent.DELETED, gson.toJson(
                        DocumentEvent(callbackId, mapOf("path" to path), error = error.toMap()))
                )
            }
        }
    }

    fun getDocumentParent(path: String): String = firestore.document(path).parent.path


    /**************** Batch ****************/
    fun startBatch() {
        batch = firestore.batch()
    }

    fun setBatch(path: String, documentData: Map<String, Any>, merge: Boolean) {
        val docRef: DocumentReference = firestore.document(path)
        when {
            merge -> batch?.set(docRef, documentData, SetOptions.merge())
            else -> batch?.set(docRef, documentData)
        }
    }

    fun updateBatch(path: String, documentData: Map<String, Any>) {
        val docRef: DocumentReference = firestore.document(path)
        batch?.update(docRef, documentData)
    }

    fun deleteBatch(path: String) {
        val docRef: DocumentReference = firestore.document(path)
        batch?.delete(docRef)
    }

    fun commitBatch(callbackId: String?) {
        batch?.commit()?.addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(BatchEvent.COMPLETE, gson.toJson(BatchEvent(callbackId)))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(BatchEvent.COMPLETE, gson.toJson(
                        NetworkEvent(callbackId, error.toMap()))
                )
            }
        }
    }

    fun enableNetwork(callbackId: String?) {
        firestore.enableNetwork().addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(NetworkEvent.ENABLED, gson.toJson(NetworkEvent(callbackId)))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(NetworkEvent.ENABLED, gson.toJson(
                        NetworkEvent(callbackId, error.toMap()))
                )
            }
        }
    }

    fun disableNetwork(callbackId: String?) {
        firestore.disableNetwork().addOnCompleteListener { task ->
            if (callbackId == null) return@addOnCompleteListener
            if (task.isSuccessful) {
                dispatchEvent(NetworkEvent.DISABLED, gson.toJson(NetworkEvent(callbackId)))
            } else {
                val error = task.exception as FirebaseFirestoreException
                dispatchEvent(NetworkEvent.DISABLED, gson.toJson(
                        NetworkEvent(callbackId, error.toMap()))
                )
            }
        }
    }

    override val TAG: String?
        get() = this::class.java.simpleName


}