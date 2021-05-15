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

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var firestoreController: FirestoreController?
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let loggingEnabled = Bool(argv[0])
            else {
                return FreArgError().getError()
        }
        
        let settings = FirestoreSettings(argv[1])
        firestoreController = FirestoreController(context: context, loggingEnabled: loggingEnabled, settings: settings)
        return true.toFREObject()
    }
    
    func getFirestoreSettings(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return firestoreController?.getFirestoreSettings()
    }
    
    // MARK: - Documents
    
    func getDocuments(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 8,
            let path = String(argv[0]),
            let callbackId = String(argv[1]),
            let inFRE2 = argv[2],
            let inFRE3 = argv[3],
            let startAtList = [Any](argv[4]),
            let startAfterList = [Any](argv[5]),
            let endAtList = [Any](argv[6]),
            let endBeforeList = [Any](argv[7])
            else {
                return FreArgError().getError()
        }
        
        let limitTo = Int(argv[8]) ?? 10000
        let whereClauses = FREArray(inFRE2)
        let orderClauses = FREArray(inFRE3)
        
        var whereList = [Where]()
        for i: UInt in 0..<whereClauses.length {
            if let fre: FREObject = whereClauses[i],
                let fieldPath = String(fre["fieldPath"]),
                let oprtr = String(fre["operator"]),
                let val = fre["value"],
                let freK = FreObjectSwift(val).value {
                    let w = Where(fieldPath: fieldPath, operatr: oprtr, value: freK)
                    whereList.append(w)
            }
        }
        
        var orderList = [Order]()
        for i: UInt in 0..<orderClauses.length {
            if let fre: FREObject = orderClauses[i],
                let by = String(fre["by"]),
                let descending = Bool(fre["descending"]) {
                    let o = Order(by: by, descending: descending)
                    orderList.append(o)
            }
        }
        
        firestoreController?.getDocuments(path: path, callbackId: callbackId, whereList: whereList,
                                          orderList: orderList, startAtList: startAtList,
                                          startAfterList: startAfterList,
                                          endAtList: endAtList, endBeforeList: endBeforeList, limitTo: limitTo)
        
        return nil
    }
    
    func initDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return firestoreController?.initDocumentReference(path: path)?.toFREObject()
    }
    
    func documentWithAutoId(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return firestoreController?.documentWithAutoId(path: path)?.toFREObject()
    }
    
    func getDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        firestoreController?.getDocumentReference(path: path, callbackId: callbackId)
        return nil
    }
    
    private func convertFieldValues(_ documentData: [String: Any]) -> [String: Any] {
       return documentData.mapValues { it in
        var ret = it
        if ret.self is [String: AnyObject] {
            if let hm = ret as? [String: Any] {
                switch hm["methodName"] as? String {
                case "FieldValue.increment":
                    if let operand = hm["operand"] as? Double {
                        ret = FieldValue.increment(operand)
                    }
                    if let operand = hm["operand"] as? Int {
                        ret = FieldValue.increment(Double(operand))
                    }
                case "FieldValue.serverTimestamp":
                    ret = FieldValue.serverTimestamp()
                case "FieldValue.delete":
                    ret = FieldValue.delete()
                default: break
                }
            }
        }
        return ret
       }
    }
    
    func setDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let path = String(argv[0]),
            let documentData = [String: Any](argv[2]),
            let merge = Bool(argv[3])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        firestoreController?.setDocumentReference(path: path, callbackId: callbackId,
                                                  documentData: convertFieldValues(documentData), merge: merge)
        return nil
    }
    
    func updateDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let documentData = [String: Any](argv[2])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        firestoreController?.updateDocumentReference(path: path, callbackId: callbackId,
                                                     documentData: convertFieldValues(documentData))
        return nil
    }
    
    func deleteDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        firestoreController?.deleteDocumentReference(path: path, callbackId: callbackId)
        return nil
    }
    
    func getDocumentParent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return firestoreController?.getDocumentParent(path: path)?.toFREObject()
    }
    
    func addSnapshotListenerDocument(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let callbackId = String(argv[1]),
            let callbackCallerId = String(argv[2])
            else {
                return FreArgError().getError()
        }
        firestoreController?.addSnapshotListenerDocument(path: path, callbackId: callbackId,
                                                         callbackCallerId: callbackCallerId)
        return nil
    }
    
    func removeSnapshotListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        firestoreController?.removeSnapshotListener(callbackId: callbackId)
        return nil
    }
    
    // MARK: - Collections
    
    func initCollectionReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return firestoreController?.initCollectionReference(path: path)?.toFREObject()
    }
    
    func getCollectionParent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return firestoreController?.getCollectionParent(path: path)?.toFREObject()
    }

    // MARK: - Batch
    
    func startBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        firestoreController?.startBatch()
        return nil
    }
    
    func commitBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        firestoreController?.commitBatch(callbackId: callbackId)
        return nil
    }
    
    func setBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let documentData = [String: Any].init(argv[1]), //not working static
            let merge = Bool(argv[2])
            else {
                return FreArgError().getError()
        }
        
        firestoreController?.setBatch(path: path, documentData: convertFieldValues(documentData), merge: merge)
        return nil
    }
    
    func deleteBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        firestoreController?.deleteBatch(path: path)
        return nil
    }
    
    func updateBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0]),
            let documentData = [String: Any](argv[1])
            else {
                return FreArgError().getError()
        }
        firestoreController?.updateBatch(path: path, documentData: convertFieldValues(documentData))
        return nil
    }
    
    // MARK: - Network
    
    func enableNetwork(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        firestoreController?.enableNetwork(callbackId: callbackId)
        return nil
    }
    
    func disableNetwork(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        firestoreController?.disableNetwork(callbackId: callbackId)
        return nil
    }
    
}
