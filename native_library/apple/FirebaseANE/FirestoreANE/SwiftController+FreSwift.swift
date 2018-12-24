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
        // Turn on FreSwift logging
        FreSwiftLogger.shared.context = context
    }
    
    @objc public func onLoad() {
    }
}
