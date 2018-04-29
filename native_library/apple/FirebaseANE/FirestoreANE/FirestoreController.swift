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
    var TAG: String? = "FirestoreController"
    internal var context: FreContextSwift!

    private var firestore: Firestore?
    private var batch: WriteBatch?
    private var snapshotRegistrations = [String: ListenerRegistration]()
    struct Listener {
        var asId: String
        var type: String
    }
    var listeners: [Listener] = []
    
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
    
    func getDocuments(path: String, asId: String, whereList: [Where], orderList: [Order],
                      startAtList: [Any], startAfterList: [Any], endAtList: [Any],
                      endBeforeList: [Any], limitTo: Int) {
        guard let fs = firestore else {
            return
        }
        var q: Query = fs.collection(path)
        for w in whereList {
            switch w.operatr {
            case "==":
                q = q.whereField(w.fieldPath, isEqualTo: w.value)
            case "<":
                q = q.whereField(w.fieldPath, isLessThan: w.value)
            case ">":
                q = q.whereField(w.fieldPath, isGreaterThan: w.value)
            case ">=":
                q = q.whereField(w.fieldPath, isGreaterThanOrEqualTo: w.value)
            case "<=":
                q = q.whereField(w.fieldPath, isLessThanOrEqualTo: w.value)
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
        
        q.getDocuments { (querySnapshot, error) in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                               text: err.localizedDescription,
                                                               id: err.code).toJSONString())
                
            } else {
                if let qSnapshot: QuerySnapshot = querySnapshot {
                    if !self.hasEventListener(asId: asId, type: QueryEvent.QUERY_SNAPSHOT) { return }
                    self.sendEvent(name: QueryEvent.QUERY_SNAPSHOT,
                                   value: QueryEvent(eventId: asId, data: qSnapshot.toDictionary()).toJSONString())
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
    
    func deleteDocumentReference(path: String, asId: String) {
        let docRef = firestore?.document(path)
        docRef?.delete { error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                               text: err.localizedDescription,
                                                               id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: DocumentEvent.COMPLETE) { return }
                self.sendEvent(name: DocumentEvent.COMPLETE,
                               value: DocumentEvent(eventId: asId, data: nil).toJSONString())
            }
        }
    }
    
    func getDocumentParent(path: String) -> String? {
        return firestore?.document(path).parent.path
    }
    
    func addSnapshotListenerDocument(path: String, asId: String) {
        guard let docRef = firestore?.document(path) else {
            return
        }
        snapshotRegistrations[asId] = docRef.addSnapshotListener({ document, error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                               text: err.localizedDescription,
                                                               id: err.code).toJSONString())
            } else {
                if let document = document {
                    if !self.hasEventListener(asId: asId, type: DocumentEvent.SNAPSHOT) { return }
                    self.sendEvent(name: DocumentEvent.SNAPSHOT,
                                   value: DocumentEvent(
                                    eventId: asId, data: document.toDictionary(), realtime: true).toJSONString()
                    )
                }
            }
        })
    }
    
    func removeSnapshotListener(asId: String) {
        snapshotRegistrations.removeValue(forKey: asId)
    }
    
    func getDocumentReference(path: String, asId: String) {
        let docRef = firestore?.document(path)
        docRef?.getDocument { snapshot, error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                          text: err.localizedDescription,
                                                          id: err.code).toJSONString())
            } else {
                if let document = snapshot {
                    if !self.hasEventListener(asId: asId, type: DocumentEvent.SNAPSHOT) { return }
                    self.sendEvent(name: DocumentEvent.SNAPSHOT,
                                   value: DocumentEvent(eventId: asId, data: document.toDictionary()).toJSONString())
                }
            }
        }   
    }
    
    func setDocumentReference(path: String, asId: String, documentData: [String: Any], merge: Bool) {
        guard let docRef: DocumentReference = firestore?.document(path) else {
            return
        }
        if merge {
            docRef.setData(documentData, options: .merge(), completion: { error in
                if let err = error as NSError? {
                    self.trace("Error writing document: \(err)")
                    if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                    self.sendEvent(name: FirestoreErrorEvent.ERROR,
                                   value: FirestoreErrorEvent(eventId: asId,
                                                                   text: err.localizedDescription,
                                                                   id: err.code).toJSONString())
                    
                } else {
                    self.trace("Document successfully written!")
                    if !self.hasEventListener(asId: asId, type: DocumentEvent.COMPLETE) { return }
                    self.sendEvent(name: DocumentEvent.COMPLETE,
                                   value: DocumentEvent(eventId: asId, data: nil).toJSONString())
                    
                }
            })
        } else {
            docRef.setData(documentData, completion: { error in
                if let err = error as NSError? {
                    self.trace("Error writing document: \(err)")
                    if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                    self.sendEvent(name: FirestoreErrorEvent.ERROR,
                                   value: FirestoreErrorEvent(eventId: asId,
                                                                   text: err.localizedDescription,
                                                                   id: err.code).toJSONString())
                    
                } else {
                    self.trace("Document successfully written!")
                    if !self.hasEventListener(asId: asId, type: DocumentEvent.COMPLETE) { return }
                    self.sendEvent(name: DocumentEvent.COMPLETE,
                                   value: DocumentEvent(eventId: asId, data: nil).toJSONString())
                    
                }
            })
        }
    }
    
    func updateDocumentReference(path: String, asId: String, documentData: [String: Any]) {
        guard let docRef: DocumentReference = firestore?.document(path) else {
            return
        }
        docRef.updateData(documentData, completion: { error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                               text: err.localizedDescription,
                                                               id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: DocumentEvent.COMPLETE) { return }
                self.sendEvent(name: DocumentEvent.COMPLETE,
                               value: DocumentEvent(eventId: asId, data: nil).toJSONString())
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
            if merge {
                batch?.setData(documentData, forDocument: docRef, options: .merge())
            } else {
                batch?.setData(documentData, forDocument: docRef)
            }
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
    
    func commitBatch(asId: String) {
        batch?.commit { error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                               text: err.localizedDescription,
                                                               id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: BatchEvent.COMPLETE) { return }
                self.sendEvent(name: BatchEvent.COMPLETE,
                               value: BatchEvent(eventId: asId).toJSONString())
            }
        }
    }
    
    // MARK: - Network
    
    func enableNetwork(asId: String) {
        firestore?.enableNetwork(completion: { error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                          text: err.localizedDescription,
                                                          id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: NetworkEvent.COMPLETE) { return }
                self.sendEvent(name: NetworkEvent.COMPLETE,
                               value: NetworkEvent(eventId: asId, enabled: true).toJSONString())
            }
        })
    }
    
    func disableNetwork(asId: String) {
        firestore?.disableNetwork(completion: { error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: FirestoreErrorEvent.ERROR) { return }
                self.sendEvent(name: FirestoreErrorEvent.ERROR,
                               value: FirestoreErrorEvent(eventId: asId,
                                                          text: err.localizedDescription,
                                                          id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: NetworkEvent.COMPLETE) { return }
                self.sendEvent(name: NetworkEvent.COMPLETE,
                               value: NetworkEvent(eventId: asId).toJSONString())
            }
        })
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(asId: String, type: String) {
        listeners.append(Listener(asId: asId, type: type))
    }
    
    func removeEventListener(asId: String, type: String) {
        for i in 0..<listeners.count {
            if listeners[i].asId == asId && listeners[i].type == type {
                listeners.remove(at: i)
                return
            }
        }
    }
    
    private func hasEventListener(asId: String, type: String) -> Bool {
        for i in 0..<listeners.count {
            if listeners[i].asId == asId && listeners[i].type == type {
                return true
            }
        }
        return false
    }
    
}
