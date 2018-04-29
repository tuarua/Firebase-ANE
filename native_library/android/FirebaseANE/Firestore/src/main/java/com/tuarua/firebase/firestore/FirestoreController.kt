package com.tuarua.firebase.firestore

import android.util.Log
import com.adobe.fre.FREContext
import com.google.firebase.FirebaseApp
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
import com.tuarua.firebase.firestore.events.*

class FirestoreController(override var context: FREContext?, loggingEnabled: Boolean,
                          settings: Map<String, Any>?) : FreKotlinController {
    private lateinit var firestore: FirebaseFirestore
    private var snapshotRegistrations: MutableMap<String, ListenerRegistration> = HashMap()
    private val gson = Gson()
    private var batch: WriteBatch? = null
    private var listeners: MutableList<Pair<String, String>> = mutableListOf()

    init {
        try {
            FirebaseFirestore.setLoggingEnabled(loggingEnabled)
            val app = FirebaseApp.getInstance()

            if (app != null) {
                firestore = FirebaseFirestore.getInstance(app)
                if (settings != null) {
                    val isPersistenceEnabled = settings.get("isPersistenceEnabled") as Boolean
                    val isSSLEnabled = settings.get("isSSLEnabled") as Boolean
                    firestore.firestoreSettings = FirebaseFirestoreSettings.Builder()
                            .setPersistenceEnabled(isPersistenceEnabled)
                            .setSslEnabled(isSSLEnabled)
                            .build()
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

    fun getFirestoreSettings(): FirebaseFirestoreSettings {
        return firestore.firestoreSettings
    }

    /**************** Collections ****************/

    fun initCollectionReference(path: String): String {
        val colRef: CollectionReference = firestore.collection(path)
        return colRef.id
    }

    fun getCollectionParent(path: String): String? {
        return firestore.collection(path).parent?.path
    }

    /**************** Documents ****************/
    fun getDocuments(path: String, asId: String, whereList: MutableList<Where>,
                     orderList: MutableList<Order>, startAtList: List<Any>,
                     startAfterList: List<Any>, endAtList: List<Any>,
                     endBeforeList: List<Any>, limitTo: Int) {
        var q: Query = firestore.collection(path)
        for (w in whereList) when {
            w.operator == "==" -> q = q.whereEqualTo(w.fieldPath, w.value)
            w.operator == "<" -> q = q.whereLessThan(w.fieldPath, w.value)
            w.operator == ">" -> q = q.whereGreaterThan(w.fieldPath, w.value)
            w.operator == ">=" -> q = q.whereGreaterThanOrEqualTo(w.fieldPath, w.value)
            w.operator == "<=" -> q = q.whereLessThanOrEqualTo(w.fieldPath, w.value)
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
                if (!hasEventListener(asId, QueryEvent.QUERY_SNAPSHOT)) return@addOnCompleteListener
                val qSnapshot: QuerySnapshot = task.result
                val docChanges = qSnapshot.documentChanges
                //https://firebase.google.com/docs/reference/android/com/google/firebase/firestore/DocumentChange
                sendEvent(QueryEvent.QUERY_SNAPSHOT, gson.toJson(QueryEvent(asId, mapOf(
                        "metadata" to mapOf(
                                "isFromCache" to qSnapshot.metadata.isFromCache,
                                "hasPendingWrites" to qSnapshot.metadata.hasPendingWrites()),
                        "documentChanges" to docChanges.map {
                            mapOf(
                                    "type" to it.type.ordinal,
                                    "newIndex" to it.newIndex,
                                    "oldIndex" to it.oldIndex,
                                    "id" to it.document.id)
                        },
                        "documents" to qSnapshot.map {
                            mapOf(
                                    "id" to it.id,
                                    "data" to it.data,
                                    "exists" to it.exists(),
                                    "metadata" to mapOf(
                                            "isFromCache" to it.metadata.isFromCache,
                                            "hasPendingWrites" to it.metadata.hasPendingWrites()
                                    )
                            )
                        }))))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun initDocumentReference(path: String): String {
        val docRef: DocumentReference = firestore.document(path)
        return docRef.id
    }

    fun documentWithAutoId(path: String): String {
        val colRef: CollectionReference = firestore.collection(path)
        val docRef: DocumentReference = colRef.document()
        return docRef.path
    }

    fun getDocumentReference(path: String, asId: String) {
        val docRef: DocumentReference = firestore.document(path)
        docRef.get().addOnCompleteListener { task ->
            val documentSnapshot: DocumentSnapshot = task.result
            if (task.isSuccessful) {
                if (!hasEventListener(asId, DocumentEvent.SNAPSHOT)) {
                    return@addOnCompleteListener
                }
                sendEvent(DocumentEvent.SNAPSHOT, gson.toJson(DocumentEvent(asId,
                        mapOf("id" to documentSnapshot.id,
                                "data" to documentSnapshot.data,
                                "exists" to documentSnapshot.exists(),
                                "metadata" to mapOf("isFromCache" to documentSnapshot.metadata.isFromCache,
                                        "hasPendingWrites" to documentSnapshot.metadata.hasPendingWrites())
                        ))))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun addSnapshotListenerDocument(path: String, asId: String) {
        val docRef: DocumentReference = firestore.document(path)
        snapshotRegistrations[asId] = docRef.addSnapshotListener { documentSnapshot, e ->
            when (e) {
                null -> if (documentSnapshot != null) {
                    if (!hasEventListener(asId, DocumentEvent.SNAPSHOT)) {
                        return@addSnapshotListener
                    }
                    sendEvent(DocumentEvent.SNAPSHOT, gson.toJson(DocumentEvent(asId,
                            mapOf("id" to documentSnapshot.id,
                                    "data" to documentSnapshot.data,
                                    "exists" to documentSnapshot.exists(),
                                    "metadata" to mapOf("isFromCache" to documentSnapshot.metadata.isFromCache,
                                            "hasPendingWrites" to documentSnapshot.metadata.hasPendingWrites())
                            ), true)))
                }
                else -> {
                    if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                        return@addSnapshotListener
                    }
                    sendEvent(FirestoreErrorEvent.ERROR,
                            gson.toJson(FirestoreErrorEvent(asId, e.message, e.code.ordinal)))
                }
            }
        }
    }

    fun removeSnapshotListener(asId: String) {
        snapshotRegistrations[asId]?.remove()
    }

    fun setDocumentReference(path: String, asId: String, documentData: Map<String, Any>, merge: Boolean) {
        val docRef: DocumentReference = firestore.document(path)
        if (merge) docRef.set(documentData, SetOptions.merge()).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, DocumentEvent.COMPLETE)) {
                    return@addOnCompleteListener
                }
                sendEvent(DocumentEvent.COMPLETE, gson.toJson(DocumentEvent(asId, null)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        } else docRef.set(documentData).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, DocumentEvent.COMPLETE)) {
                    return@addOnCompleteListener
                }
                sendEvent(DocumentEvent.COMPLETE, gson.toJson(DocumentEvent(asId, null)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun updateDocumentReference(path: String, asId: String, documentData: Map<String, Any>) {
        val docRef: DocumentReference = firestore.document(path)
        docRef.update(documentData).addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, DocumentEvent.COMPLETE)) {
                    return@addOnCompleteListener
                }
                sendEvent(DocumentEvent.COMPLETE, gson.toJson(DocumentEvent(asId, null)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun deleteDocumentReference(path: String, asId: String) {
        val docRef: DocumentReference = firestore.document(path)
        docRef.delete().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, DocumentEvent.COMPLETE)) {
                    return@addOnCompleteListener
                }
                sendEvent(DocumentEvent.COMPLETE, gson.toJson(DocumentEvent(asId, null)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun getDocumentParent(path: String): String {
        return firestore.document(path).parent.path
    }


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

    fun commitBatch(asId: String) {
        batch?.commit()?.addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, BatchEvent.COMPLETE)) return@addOnCompleteListener
                sendEvent(BatchEvent.COMPLETE, gson.toJson(BatchEvent(asId)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun enableNetwork(asId: String) {
        firestore.enableNetwork().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, NetworkEvent.COMPLETE)) return@addOnCompleteListener
                sendEvent(NetworkEvent.COMPLETE, gson.toJson(NetworkEvent(asId, true)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
    }

    fun disableNetwork(asId: String) {
        firestore.disableNetwork().addOnCompleteListener { task ->
            if (task.isSuccessful) {
                if (!hasEventListener(asId, NetworkEvent.COMPLETE)) return@addOnCompleteListener
                sendEvent(NetworkEvent.COMPLETE, gson.toJson(NetworkEvent(asId)))
            } else {
                if (!hasEventListener(asId, FirestoreErrorEvent.ERROR)) {
                    return@addOnCompleteListener
                }
                val error = task.exception as FirebaseFirestoreException
                sendEvent(FirestoreErrorEvent.ERROR,
                        gson.toJson(FirestoreErrorEvent(asId, error.message, error.code.ordinal)))
            }
        }
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