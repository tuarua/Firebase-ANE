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
import FirebaseStorage

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var storageController: StorageController?
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        storageController = StorageController(context: context, url: String(argv[0]))
        return true.toFREObject()
    }
    
    func getReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1
            else {
                return FreArgError().getError()
        }
        return storageController?.getReference(path: String(argv[0]),
                                               url: String(argv[1]))?.toFREObject()
    }
    
    func getFile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let destinationFile = String(argv[1]),
            let callbackId = String(argv[2])
            else {
                return FreArgError().getError()
        }
        storageController?.getFile(path: path, destinationFile: destinationFile, callbackId: callbackId)
        return nil
    }
    
    func getParent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return storageController?.getParent(path: path)?.toFREObject()
    }
    
    func getRoot(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return storageController?.getRoot(path: path)?.toFREObject()
    }
    
    func deleteReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        storageController?.deleteReference(path: path, callbackId: callbackId)
        return nil
    }
    
    func putBytes(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let path = String(argv[0]),
            let callbackId = String(argv[1]),
            let inFRE2 = argv[2]
            else {
                return FreArgError().getError()
        }
        let metadata = StorageMetadata(argv[3])
        let ba = FreByteArraySwift.init(freByteArray: inFRE2)
        if let byteData = ba.value {
            storageController?.putBytes(path: path, callbackId: callbackId, bytes: byteData, metadata: metadata)
        }
        ba.releaseBytes()
        return nil
    }
    
    func putFile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let path = String(argv[0]),
            let callbackId = String(argv[1]),
            let filePath = String(argv[2])
            else {
                return FreArgError().getError()
        }
        
        let metadata = StorageMetadata(argv[3])
        
        storageController?.putFile(path: path, callbackId: callbackId, filePath: filePath, metadata: metadata)
        return nil
    }
    
    func getDownloadUrl(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        storageController?.getDownloadUrl(path: path, callbackId: callbackId)
        return nil
    }
    
    func getBytes(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let callbackId = String(argv[2])
            else {
                return FreArgError().getError()
        }
        let maxDownloadSizeBytes = Int(argv[1])
        storageController?.getBytes(path: path, maxDownloadSizeBytes: maxDownloadSizeBytes, callbackId: callbackId)
        return nil
    }
    
    func getMetadata(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let path = String(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        storageController?.getMetadata(path: path, callbackId: callbackId)
        return nil
    }
    
    func updateMetadata(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let path = String(argv[0]),
            let metadata = StorageMetadata(argv[2])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        storageController?.updateMetadata(path: path, callbackId: callbackId, metadata: metadata)
        return nil
    }
    
    // MARK: - Setters / Getters
    
    func getMaxDownloadRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return storageController?.maxDownloadRetryTime.toFREObject()
    }
    func getMaxUploadRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return storageController?.maxUploadRetryTime.toFREObject()
    }
    func getMaxOperationRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return storageController?.maxOperationRetryTime.toFREObject()
    }
    
    func setMaxDownloadRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = Double(argv[0])
            else {
                return FreArgError().getError()
        }
        storageController?.maxDownloadRetryTime = value
        return nil
    }
    func setMaxUploadRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = Double(argv[0])
            else {
                return FreArgError().getError()
        }
        storageController?.maxUploadRetryTime = value
        return nil
    }
    func setMaxOperationRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = Double(argv[0])
            else {
                return FreArgError().getError()
        }
        storageController?.maxOperationRetryTime = value
        return nil
    }
    
    // MARK: - Tasks
    
    func pauseTask(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        storageController?.pauseTask(callbackId: callbackId)
        return nil
    }
    
    func resumeTask(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        storageController?.resumeTask(callbackId: callbackId)
        return nil
    }
    
    func cancelTask(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        storageController?.cancelTask(callbackId: callbackId)
        return nil
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0]),
            let type = String(argv[1])
            else {
                return FreArgError().getError()
        }
        storageController?.addEventListener(callbackId: callbackId, type: type)
        return nil
    }
    
    func removeEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0]),
            let type = String(argv[1])
            else {
                return FreArgError().getError()
        }
        storageController?.removeEventListener(callbackId: callbackId, type: type)
        return nil
    }
    
}
