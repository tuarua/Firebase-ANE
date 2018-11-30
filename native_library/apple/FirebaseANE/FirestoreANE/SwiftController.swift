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
                return FreArgError(message: "initController").getError(#file, #line, #column)
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
            let asId = String(argv[1]),
            let inFRE2 = argv[2],
            let inFRE3 = argv[3],
            let startAtList = [Any](argv[4]),
            let startAfterList = [Any](argv[5]),
            let endAtList = [Any](argv[6]),
            let endBeforeList = [Any](argv[7])
            else {
                return FreArgError(message: "getDocuments").getError(#file, #line, #column)
        }
        
        let limitTo = Int(argv[8]) ?? 10000
        let whereClauses = FREArray(inFRE2)
        let orderClauses = FREArray(inFRE3)
        
        var whereList = [Where]()
        for i: UInt in 0..<whereClauses.length {
            if let fre = whereClauses[i],
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
            if let fre = orderClauses[i],
                let by = String(fre["by"]),
                let descending = Bool(fre["descending"]) {
                    let o = Order(by: by, descending: descending)
                    orderList.append(o)
            }
        }
        
        trace("getDocuments", path, asId, limitTo)
        
        firestoreController?.getDocuments(path: path, eventId: asId, whereList: whereList,
                                          orderList: orderList, startAtList: startAtList,
                                          startAfterList: startAfterList,
                                          endAtList: endAtList, endBeforeList: endBeforeList, limitTo: limitTo)
        
        return nil
    }
    
    func initDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError(message: "initDocumentReference").getError(#file, #line, #column)
        }
        return firestoreController?.initDocumentReference(path: path)?.toFREObject()
    }
    
    func documentWithAutoId(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError(message: "documentWithAutoId").getError(#file, #line, #column)
        }
        return firestoreController?.documentWithAutoId(path: path)?.toFREObject()
    }
    
    func getDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0]),
            let eventId = String(argv[1])
            else {
                return FreArgError(message: "getDocumentReference").getError(#file, #line, #column)
        }
        firestoreController?.getDocumentReference(path: path, eventId: eventId)
        return nil
    }
    
    func setDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let path = String(argv[0]),
            let documentData = [String: Any](argv[2]),
            let merge = Bool(argv[3])
            else {
                return FreArgError(message: "setDocumentReference").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        firestoreController?.setDocumentReference(path: path, eventId: eventId,
                                                  documentData: documentData, merge: merge)
        return nil
    }
    
    func updateDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let documentData = [String: Any](argv[2])
            else {
                return FreArgError(message: "updateDocumentReference").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        firestoreController?.updateDocumentReference(path: path, eventId: eventId, documentData: documentData)
        return nil
    }
    
    func deleteDocumentReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0])
            else {
                return FreArgError(message: "deleteDocumentReference").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        firestoreController?.deleteDocumentReference(path: path, eventId: eventId)
        return nil
    }
    
    func getDocumentParent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError(message: "getDocumentParent").getError(#file, #line, #column)
        }
        return firestoreController?.getDocumentParent(path: path)?.toFREObject()
    }
    
    func addSnapshotListenerDocument(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let eventId = String(argv[1]),
            let asId = String(argv[2])
            else {
                return FreArgError(message: "addSnapshotListenerDocument").getError(#file, #line, #column)
        }
        firestoreController?.addSnapshotListenerDocument(path: path, eventId: eventId, asId: asId)
        return nil
    }
    
    func removeSnapshotListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let asId = String(argv[0])
            else {
                return FreArgError(message: "removeSnapshotListener").getError(#file, #line, #column)
        }
        firestoreController?.removeSnapshotListener(asId: asId)
        return nil
    }
    
    // MARK: - Collections
    
    func initCollectionReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError(message: "initCollectionReference").getError(#file, #line, #column)
        }
        return firestoreController?.initCollectionReference(path: path)?.toFREObject()
    }
    
    func getCollectionParent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError(message: "getCollectionParent").getError(#file, #line, #column)
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
                return FreArgError(message: "commitBatch").getError(#file, #line, #column)
        }
        let eventId = String(argv[0])
        firestoreController?.commitBatch(eventId: eventId)
        return nil
    }
    
    func setBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let documentData = [String: Any].init(argv[1]), //not working static
            let merge = Bool(argv[2])
            else {
                return FreArgError(message: "setBatch").getError(#file, #line, #column)
        }
        
        info(documentData.debugDescription)
        
        // firestoreController?.setBatch(path: path, documentData: documentData, merge: merge)
        return nil
    }
    
    func deleteBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError(message: "deleteBatch").getError(#file, #line, #column)
        }
        firestoreController?.deleteBatch(path: path)
        return nil
    }
    
    func updateBatch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0]),
            let documentData = [String: Any](argv[1])
            else {
                return FreArgError(message: "updateBatch").getError(#file, #line, #column)
        }
        firestoreController?.updateBatch(path: path, documentData: documentData)
        return nil
    }
    
    // MARK: - Network
    
    func enableNetwork(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError(message: "enableNetwork").getError(#file, #line, #column)
        }
        let eventId = String(argv[0])
        firestoreController?.enableNetwork(eventId: eventId)
        return nil
    }
    
    func disableNetwork(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError(message: "disableNetwork").getError(#file, #line, #column)
        }
        let eventId = String(argv[0])
        firestoreController?.disableNetwork(eventId: eventId)
        return nil
    }
    
}
