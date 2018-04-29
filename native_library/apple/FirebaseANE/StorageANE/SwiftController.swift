import Foundation
import FreSwift
import FirebaseStorage

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
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
                return ArgCountError(message: "initController").getError(#file, #line, #column)
        }
        storageController = StorageController(context: context, url: String(argv[0]))
        return true.toFREObject()
    }
    
    func getReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1
            else {
                return ArgCountError(message: "getReference").getError(#file, #line, #column)
        }
        return storageController?.getReference(path: String(argv[0]),
                                               url: String(argv[1]))?.toFREObject()
    }
    
    func getFile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let sc = storageController,
            let path = String(argv[0]),
            let destinationFile = String(argv[1]),
            let asId = String(argv[2])
            else {
                return ArgCountError(message: "getFile").getError(#file, #line, #column)
        }
        sc.getFile(path: path, destinationFile: destinationFile, asId: asId)
        return nil
    }
    
    func getParent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let path = String(argv[0])
            else {
                return ArgCountError(message: "getParent").getError(#file, #line, #column)
        }
        return sc.getParent(path: path)?.toFREObject()
    }
    
    func getRoot(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let path = String(argv[0])
            else {
                return ArgCountError(message: "getRoot").getError(#file, #line, #column)
        }
        return sc.getRoot(path: path)?.toFREObject()
    }
    
    func deleteReference(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[1])
            else {
                return ArgCountError(message: "deleteReference").getError(#file, #line, #column)
        }
        
        sc.deleteReference(path: path, asId: asId)
        return nil
    }
    
    func putBytes(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[1]),
            let inFRE2 = argv[2]
            else {
                return ArgCountError(message: "putBytes").getError(#file, #line, #column)
        }
        let metadata = StorageMetadata(argv[3])
        let ba = FreByteArraySwift.init(freByteArray: inFRE2)
        if let byteData = ba.value {
            sc.putBytes(path: path, asId: asId, bytes: byteData, metadata: metadata)
        }
        ba.releaseBytes()
        return nil
    }
    
    func putFile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[1]),
            let filePath = String(argv[2])
            else {
                return ArgCountError(message: "putFile").getError(#file, #line, #column)
        }
        
        let metadata = StorageMetadata(argv[3])
        
        sc.putFile(path: path, asId: asId, filePath: filePath, metadata: metadata)
        return nil
    }
    
    func getDownloadUrl(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[1])
            else {
                return ArgCountError(message: "getDownloadUrl").getError(#file, #line, #column)
        }
        sc.getDownloadUrl(path: path, asId: asId)
        return nil
    }
    
    func getBytes(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[2])
            else {
                return ArgCountError(message: "getBytes").getError(#file, #line, #column)
        }
        let maxDownloadSizeBytes = Int(argv[1])
        sc.getBytes(path: path, maxDownloadSizeBytes: maxDownloadSizeBytes, asId: asId)
        return nil
    }
    
    func getMetadata(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[1])
            else {
                return ArgCountError(message: "getMetadata").getError(#file, #line, #column)
        }
        sc.getMetadata(path: path, asId: asId)
        return nil
    }
    
    func updateMetadata(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let sc = storageController,
            let path = String(argv[0]),
            let asId = String(argv[1]),
            let metadata = StorageMetadata(argv[2])
            else {
                return ArgCountError(message: "updateMetadata").getError(#file, #line, #column)
        }
        sc.updateMetadata(path: path, asId: asId, metadata: metadata)
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
            let sc = storageController,
            let value = Double(argv[0])
            else {
                return ArgCountError(message: "setMaxDownloadRetryTime").getError(#file, #line, #column)
        }
        sc.maxDownloadRetryTime = value
        return nil
    }
    func setMaxUploadRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let value = Double(argv[0])
            else {
                return ArgCountError(message: "setMaxUploadRetryTime").getError(#file, #line, #column)
        }
        sc.maxUploadRetryTime = value
        return nil
    }
    func setMaxOperationRetryTime(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let value = Double(argv[0])
            else {
                return ArgCountError(message: "setMaxUploadRetryTime").getError(#file, #line, #column)
        }
        sc.maxOperationRetryTime = value
        return nil
    }
    
    // MARK: - Tasks
    
    func pauseTask(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let asId = String(argv[0])
            else {
                return ArgCountError(message: "pauseTask").getError(#file, #line, #column)
        }
        sc.pauseTask(asId: asId)
        return nil
    }
    
    func resumeTask(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let asId = String(argv[0])
            else {
                return ArgCountError(message: "resumeTask").getError(#file, #line, #column)
        }
        sc.resumeTask(asId: asId)
        return nil
    }
    
    func cancelTask(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let sc = storageController,
            let asId = String(argv[0])
            else {
                return ArgCountError(message: "cancelTask").getError(#file, #line, #column)
        }
        sc.cancelTask(asId: asId)
        return nil
    }
    
    // MARK: - AS Event Listeners
    
    // MARK: - AS Event Listeners
    
    func addEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let asId = String(argv[0]),
            let type = String(argv[1])
            else {
                return ArgCountError(message: "addEventListener").getError(#file, #line, #column)
        }
        storageController?.addEventListener(asId: asId, type: type)
        return nil
    }
    
    func removeEventListener(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let asId = String(argv[0]),
            let type = String(argv[1])
            else {
                return ArgCountError(message: "removeEventListener").getError(#file, #line, #column)
        }
        storageController?.removeEventListener(asId: asId, type: type)
        return nil
    }
    
}
