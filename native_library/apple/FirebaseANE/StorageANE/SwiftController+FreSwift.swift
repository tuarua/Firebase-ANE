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
        functionsToSet["\(prefix)addEventListener"] = addEventListener
        functionsToSet["\(prefix)removeEventListener"] = removeEventListener
        functionsToSet["\(prefix)getReference"] = getReference
        functionsToSet["\(prefix)getFile"] = getFile
        functionsToSet["\(prefix)getParent"] = getParent
        functionsToSet["\(prefix)getRoot"] = getRoot
        functionsToSet["\(prefix)deleteReference"] = deleteReference
        functionsToSet["\(prefix)putBytes"] = putBytes
        functionsToSet["\(prefix)putFile"] = putFile
        functionsToSet["\(prefix)pauseTask"] = pauseTask
        functionsToSet["\(prefix)resumeTask"] = resumeTask
        functionsToSet["\(prefix)cancelTask"] = cancelTask
        functionsToSet["\(prefix)getDownloadUrl"] = getDownloadUrl
        functionsToSet["\(prefix)getBytes"] = getBytes
        functionsToSet["\(prefix)getMetadata"] = getMetadata
        functionsToSet["\(prefix)updateMetadata"] = updateMetadata
        functionsToSet["\(prefix)getMaxDownloadRetryTime"] = getMaxDownloadRetryTime
        functionsToSet["\(prefix)getMaxUploadRetryTime"] = getMaxUploadRetryTime
        functionsToSet["\(prefix)getMaxOperationRetryTime"] = getMaxOperationRetryTime
        functionsToSet["\(prefix)setMaxDownloadRetryTime"] = setMaxDownloadRetryTime
        functionsToSet["\(prefix)setMaxUploadRetryTime"] = setMaxUploadRetryTime
        functionsToSet["\(prefix)setMaxOperationRetryTime"] = setMaxOperationRetryTime

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
