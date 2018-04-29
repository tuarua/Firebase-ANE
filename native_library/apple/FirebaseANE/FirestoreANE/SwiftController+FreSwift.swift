import Foundation
import FreSwift

extension SwiftController: FreSwiftMainController {
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)createGUID"] = createGUID
        functionsToSet["\(prefix)getFirestoreSettings"] = getFirestoreSettings
        functionsToSet["\(prefix)getDocuments"] = getDocuments
        functionsToSet["\(prefix)initDocumentReference"] = initDocumentReference
        functionsToSet["\(prefix)getDocumentReference"] = getDocumentReference
        functionsToSet["\(prefix)setDocumentReference"] = setDocumentReference
        functionsToSet["\(prefix)updateDocumentReference"] = updateDocumentReference
        functionsToSet["\(prefix)deleteDocumentReference"] = deleteDocumentReference
        functionsToSet["\(prefix)getDocumentParent"] = getDocumentParent
        functionsToSet["\(prefix)documentWithAutoId"] = documentWithAutoId
        functionsToSet["\(prefix)initCollectionReference"] = initCollectionReference
        functionsToSet["\(prefix)getCollectionParent"] = getCollectionParent
        functionsToSet["\(prefix)addSnapshotListenerDocument"] = addSnapshotListenerDocument
        functionsToSet["\(prefix)removeSnapshotListener"] = removeSnapshotListener
        functionsToSet["\(prefix)startBatch"] = startBatch
        functionsToSet["\(prefix)commitBatch"] = commitBatch
        functionsToSet["\(prefix)setBatch"] = setBatch
        functionsToSet["\(prefix)updateBatch"] = updateBatch
        functionsToSet["\(prefix)deleteBatch"] = deleteBatch
        functionsToSet["\(prefix)enableNetwork"] = enableNetwork
        functionsToSet["\(prefix)disableNetwork"] = disableNetwork
        functionsToSet["\(prefix)addEventListener"] = addEventListener
        functionsToSet["\(prefix)removeEventListener"] = removeEventListener
        
        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        
        return arr
    }
    
    @objc public func dispose() {
    }
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    @objc public func onLoad() {
    }
}
