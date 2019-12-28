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

import Foundation
import FreSwift
import Firebase
import FirebaseFirestore

class FirestoreController: FreSwiftController {
    static var TAG = "FirestoreController"
    internal var context: FreContextSwift!

    private var firestore: Firestore?
    private var batch: WriteBatch?
    private var snapshotRegistrations = [String: ListenerRegistration]()
    
    convenience init(context: FreContextSwift, loggingEnabled: Bool, settings: FirestoreSettings?) {
        self.init()
        self.context = context
        guard let app = FirebaseApp.app() else {
            warning(">>>>>>>>>> NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
            return
        }
        if loggingEnabled {
            FirebaseConfiguration.shared.setLoggerLevel(.debug)
        }
        firestore = Firestore.firestore(app: app)
        if let settings = settings {
            firestore?.settings = settings
        }
    }
    
    func getFirestoreSettings() -> FREObject? {
        return firestore?.settings.toFREObject()
    }
    
    // MARK: - Documents
    
    func getDocuments(path: String, callbackId: String, whereList: [Where], orderList: [Order],
                      startAtList: [Any], startAfterList: [Any], endAtList: [Any],
                      endBeforeList: [Any], limitTo: Int) {
        guard let fs = firestore else {
            return
        }
        var q: Query = fs.collection(path)
        for w in whereList {
            switch w.operatr {
            case "==":
                q = q.whereField(w.fieldPath, isEqualTo: w.value!)
            case "<":
                q = q.whereField(w.fieldPath, isLessThan: w.value!)
            case ">":
                q = q.whereField(w.fieldPath, isGreaterThan: w.value!)
            case ">=":
                q = q.whereField(w.fieldPath, isGreaterThanOrEqualTo: w.value!)
            case "<=":
                q = q.whereField(w.fieldPath, isLessThanOrEqualTo: w.value!)
            default:
                break
            }
        }

        for o in orderList {
            q = q.order(by: o.by, descending: o.descending)
        }

        if !startAtList.isEmpty {
            q = q.start(at: startAtList)
        }
        if !startAfterList.isEmpty {
            q = q.start(after: startAfterList)
        }
        if !endAtList.isEmpty {
            q = q.end(at: endAtList)
        }
        if !endBeforeList.isEmpty {
            q = q.end(before: endBeforeList)
        }
        
        q = q.limit(to: limitTo)
        
        q.getDocuments { querySnapshot, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: DocumentEvent.QUERY_SNAPSHOT,
                               value: DocumentEvent(
                                callbackId: callbackId,
                                error: err).toJSONString()
                )
                
            } else {
                if let qSnapshot: QuerySnapshot = querySnapshot {
                    self.dispatchEvent(name: DocumentEvent.QUERY_SNAPSHOT,
                                   value: DocumentEvent(
                                    callbackId: callbackId,
                                    data: qSnapshot.toDictionary()).toJSONString()
                    )
                }
 
            }
        }
        
    }
    
    func initDocumentReference(path: String) -> String? {
        return firestore?.document(path).documentID
    }
    
    func documentWithAutoId(path: String) -> String? {
        return firestore?.collection(path).document().path
    }
    
    func deleteDocumentReference(path: String, callbackId: String?) {
        let docRef = firestore?.document(path)
        docRef?.delete { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: DocumentEvent.DELETED,
                               value: DocumentEvent(callbackId: callbackId,
                                                    data: ["path": path],
                                                    error: err).toJSONString())
            } else {
                self.dispatchEvent(name: DocumentEvent.DELETED,
                               value: DocumentEvent(callbackId: callbackId,
                                                    data: ["path": path]).toJSONString())
            }
        }
    }
    
    func getDocumentParent(path: String) -> String? {
        return firestore?.document(path).parent.path
    }
    
    func addSnapshotListenerDocument(path: String, callbackId: String, callbackCallerId: String) {
        guard let docRef = firestore?.document(path) else { return }
        snapshotRegistrations[callbackCallerId] = docRef.addSnapshotListener({ snapshot, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: DocumentEvent.SNAPSHOT,
                                   value: DocumentEvent(callbackId: callbackId,
                                                        data: nil,
                                                        realtime: true,
                                                        error: err).toJSONString()
                )
                
            } else {
                if let document = snapshot {
                    self.dispatchEvent(name: DocumentEvent.SNAPSHOT,
                                       value: DocumentEvent(callbackId: callbackId,
                                                             data: document.toDictionary(),
                                                             realtime: true).toJSONString()
                    )
                }
            }
        })
    }
    
    func removeSnapshotListener(callbackId: String) {
        snapshotRegistrations[callbackId]?.remove()
        snapshotRegistrations.removeValue(forKey: callbackId)
    }
    
    func getDocumentReference(path: String, callbackId: String) {
        let docRef = firestore?.document(path)
        docRef?.getDocument { snapshot, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: DocumentEvent.SNAPSHOT,
                               value: DocumentEvent(callbackId: callbackId,
                                                    error: err).toJSONString())
            } else {
                if let document = snapshot {
                    self.dispatchEvent(name: DocumentEvent.SNAPSHOT,
                                   value: DocumentEvent(callbackId: callbackId,
                                                        data: document.toDictionary()).toJSONString()
                    )
                }
            }
        }   
    }
    
    func setDocumentReference(path: String, callbackId: String?, documentData: [String: Any], merge: Bool) {
        guard let docRef: DocumentReference = firestore?.document(path) else {
            return
        }
        docRef.setData(documentData, merge: merge, completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: DocumentEvent.SET,
                               value: DocumentEvent(callbackId: callbackId,
                                                    data: ["path": path],
                                                    error: err).toJSONString())
            } else {
                self.dispatchEvent(name: DocumentEvent.SET,
                               value: DocumentEvent(callbackId: callbackId,
                                                    data: ["path": path]).toJSONString())
                
            }
        })
    }
    
    func updateDocumentReference(path: String, callbackId: String?, documentData: [String: Any]) {
        guard let docRef: DocumentReference = firestore?.document(path) else {
            return
        }
        docRef.updateData(documentData, completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: DocumentEvent.UPDATED,
                               value: DocumentEvent(callbackId: callbackId,
                                                    data: ["path": path],
                                                    error: err).toJSONString())
            } else {
                self.dispatchEvent(name: DocumentEvent.UPDATED,
                               value: DocumentEvent(callbackId: callbackId,
                                                    data: ["path": path]).toJSONString())
            }
        })
    }
    
    // MARK: - Collections
 
    func getCollectionParent(path: String) -> String? {
        return firestore?.collection(path).parent?.path
    }
    
    func initCollectionReference(path: String) -> String? {
        return firestore?.collection(path).collectionID
    }
    
    // MARK: - Batch
    
    func startBatch() {
        batch = firestore?.batch()
    }
    
    func setBatch(path: String, documentData: [String: Any], merge: Bool) {
        if let docRef: DocumentReference = firestore?.document(path) {
            batch?.setData(documentData, forDocument: docRef, merge: merge)
        }
    }
    
    func updateBatch(path: String, documentData: [String: Any]) {
        if let docRef: DocumentReference = firestore?.document(path) {
           batch?.updateData(documentData, forDocument: docRef)
        }
    }
    
    func deleteBatch(path: String) {
        if let docRef: DocumentReference = firestore?.document(path) {
            batch?.deleteDocument(docRef)
        }
    }
    
    func commitBatch(callbackId: String?) {
        batch?.commit { error in
            if let err = error as NSError? {
                if callbackId == nil { return }
                self.dispatchEvent(name: BatchEvent.COMPLETE,
                               value: BatchEvent(callbackId: callbackId,
                                                 error: err).toJSONString())
                
            } else {
                self.dispatchEvent(name: BatchEvent.COMPLETE,
                               value: BatchEvent(callbackId: callbackId).toJSONString())
            }
        }
    }
    
    // MARK: - Network
    
    func enableNetwork(callbackId: String?) {
        firestore?.enableNetwork(completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: NetworkEvent.ENABLED,
                               value: NetworkEvent(callbackId: callbackId, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: NetworkEvent.ENABLED,
                               value: NetworkEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
    func disableNetwork(callbackId: String?) {
        firestore?.disableNetwork(completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: NetworkEvent.DISABLED,
                               value: NetworkEvent(callbackId: callbackId, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: NetworkEvent.DISABLED,
                               value: NetworkEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
}
