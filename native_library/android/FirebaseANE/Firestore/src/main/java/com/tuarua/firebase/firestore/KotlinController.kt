/*
 *  Copyright 2017 Tua Rua Ltd.
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

import com.adobe.fre.FREArray
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.firebase.firestore.data.Order
import com.tuarua.firebase.firestore.data.Where
import com.tuarua.frekotlin.*
import java.util.*


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var firestoreController: FirestoreController

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("init")
        val loggingEnabled = Boolean(argv[0]) == true
        val settings = FirebaseFirestoreSettings(argv[1])
        firestoreController = FirestoreController(context, loggingEnabled, settings)
        return true.toFREObject()
    }

    fun getFirestoreSettings(ctx: FREContext, argv: FREArgv): FREObject? {
        return firestoreController.getFirestoreSettings().toFREObject()
    }

    fun getCollectionParent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getCollectionParent")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return firestoreController.getCollectionParent(path)?.toFREObject()
    }

    fun initCollectionReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("initCollectionReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return firestoreController.initCollectionReference(path).toFREObject()
    }

    fun getDocumentParent(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getDocumentParent")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return firestoreController.getDocumentParent(path).toFREObject()
    }

    fun getDocuments(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 8 } ?: return FreArgException("getDocuments")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        try {
            val whereClauses: FREArray? = FREArray(freObject = argv[2])
            val orderClauses: FREArray? = FREArray(freObject = argv[3])
            val startAtClauses: FREArray? = FREArray(freObject = argv[4])
            val startAfterClauses: FREArray? = FREArray(freObject = argv[5])
            val endAtClauses: FREArray? = FREArray(freObject = argv[6])
            val endBeforeClauses: FREArray? = FREArray(freObject = argv[7])
            val limitTo = Int(argv[8]) ?: 10000
            val whereList = mutableListOf<Where>()
            for (i in 1..(whereClauses?.length ?: 0)) {
                val fre: FREObject? = whereClauses?.at((i - 1).toInt())
                if (fre != null) {
                    val fieldPath = String(fre["fieldPath"])
                    val operator = String(fre["operator"])
                    val value = fre["value"]
                    if (fieldPath != null && operator != null && value != null) {
                        val freK = FreObjectKotlin(value).value
                        if (freK != null) {
                            val w = Where(fieldPath, operator, freK)
                            whereList.add(w)
                        }
                    }
                }
            }

            val orderList = mutableListOf<Order>()
            for (i in 1..(orderClauses?.length ?: 0)) {
                val fre: FREObject? = orderClauses?.at((i - 1).toInt())
                if (fre != null) {
                    val by = String(fre["by"])
                    val descending = Boolean(fre["descending"]) != false
                    if (by != null) {
                        val o = Order(by, descending)
                        orderList.add(o)
                    }
                }

            }

            val startAtList = (1..(startAtClauses?.length?.toInt() ?: 0)).mapNotNull {
                FreObjectKotlin(startAtClauses?.at(it - 1)).value
            }
            val startAfterList = (1..(startAfterClauses?.length?.toInt() ?: 0)).mapNotNull {
                FreObjectKotlin(startAfterClauses?.at(it - 1)).value
            }
            val endAtList = (1..(endAtClauses?.length?.toInt() ?: 0)).mapNotNull {
                FreObjectKotlin(endAtClauses?.at(it - 1)).value
            }
            val endBeforeList = (1..(endBeforeClauses?.length?.toInt() ?: 0)).mapNotNull {
                FreObjectKotlin(endBeforeClauses?.at(it - 1)).value
            }

            firestoreController.getDocuments(path, asId, whereList, orderList,
                    startAtList, startAfterList, endAtList, endBeforeList, limitTo)
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun initDocumentReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("initDocumentReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return firestoreController.initDocumentReference(path).toFREObject()
    }

    fun getDocumentReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("getDocumentReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val asId = String(argv[1]) ?: return FreConversionException("asId")
        firestoreController.getDocumentReference(path, asId)
        return null
    }

    fun addSnapshotListenerDocument(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("addSnapshotListenerDocument")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val eventId = String(argv[1]) ?: return FreConversionException("eventId")
        val asId = String(argv[2]) ?: return FreConversionException("asId")
        firestoreController.addSnapshotListenerDocument(path, eventId, asId)
        return null
    }

    fun removeSnapshotListener(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("removeSnapshotListener")
        val asId = String(argv[0]) ?: return FreConversionException("asId")
        firestoreController.removeSnapshotListener(asId)
        return null
    }

    fun setDocumentReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 3 } ?: return FreArgException("setDocumentReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val eventId = String(argv[1])
        val documentData: Map<String, Any> = Map(argv[2])
                ?: return FreConversionException("documentData")
        val merge = Boolean(argv[3]) ?: return FreConversionException("merge")
        firestoreController.setDocumentReference(path, eventId, documentData, merge)
        return null
    }

    fun updateDocumentReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("updateDocumentReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val eventId = String(argv[1])
        val documentData: Map<String, Any> = Map(argv[2])
                ?: return FreConversionException("documentData")
        firestoreController.updateDocumentReference(path, eventId, documentData)
        return null
    }

    fun deleteDocumentReference(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("deleteDocumentReference")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val eventId = String(argv[1])
        firestoreController.deleteDocumentReference(path, eventId)
        return null
    }

    fun documentWithAutoId(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("documentWithAutoId")
        val path = String(argv[0]) ?: return FreConversionException("path")
        return firestoreController.documentWithAutoId(path).toFREObject()
    }

    /**************** Batch ****************/
    fun startBatch(ctx: FREContext, argv: FREArgv): FREObject? {
        firestoreController.startBatch()
        return null
    }

    fun setBatch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("setBatch")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val documentData: Map<String, Any> = Map(argv[1])
                ?: return FreConversionException("documentData")
        val merge = Boolean(argv[2]) ?: return FreConversionException("merge")
        firestoreController.setBatch(path, documentData, merge)
        return null
    }

    fun deleteBatch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("deleteBatch")
        val path = String(argv[0]) ?: return FreConversionException("path")
        firestoreController.deleteBatch(path)
        return null
    }

    fun updateBatch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("updateBatch")
        val path = String(argv[0]) ?: return FreConversionException("path")
        val documentData: Map<String, Any> = Map(argv[1])
                ?: return FreConversionException("documentData")
        firestoreController.updateBatch(path, documentData)
        return null
    }

    fun commitBatch(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("commitBatch")
        val asId = String(argv[0])
        firestoreController.commitBatch(asId)
        return null
    }

    fun enableNetwork(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("commitBatch")
        val eventId = String(argv[0])
        firestoreController.enableNetwork(eventId)
        return null
    }

    fun disableNetwork(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("commitBatch")
        val eventId = String(argv[0])
        firestoreController.disableNetwork(eventId)
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