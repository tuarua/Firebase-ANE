import FreSwift
import Foundation
import Firebase
import FirebaseStorage

class StorageController: FreSwiftController {
    var TAG: String? = "StorageController"
    internal var context: FreContextSwift!
    private var storage: Storage?
    private var uploadTasks: [String: StorageUploadTask] = [:]
    private var downloadTasks: [String: StorageDownloadTask] = [:]
    
    struct Listener {
        var asId: String
        var type: String
    }
    var listeners: [Listener] = []
    
    convenience init(context: FreContextSwift, url: String?) {
        self.init()
        self.context = context
        guard let app = FirebaseApp.app() else {
            warning(">>>>>>>>>> NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
            return
        }
        if let url = url {
            storage = Storage.storage(app: app, url: url)
        } else {
            storage = Storage.storage(app: app)
        }
    }
    
    func getReference(path: String?, url: String?) -> StorageReference? {
        if path == nil && url == nil {
            return storage?.reference()
        } else if let p = path {
            return storage?.reference(withPath: p)
        } else if let u = url {
            return storage?.reference(forURL: u)
        }
        return nil
    }
    
    func getFile(path: String, destinationFile: String, asId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        if let localURL = URL(string: destinationFile) {
            let downloadTask = storageRef.write(toFile: localURL) { url, error in
                if let err = error as NSError? {
                    if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                    self.sendEvent(name: StorageErrorEvent.ERROR,
                                   value: StorageErrorEvent(eventId: asId,
                                                            text: err.localizedDescription,
                                                            id: err.code).toJSONString())
                } else {
                    if !self.hasEventListener(asId: asId, type: StorageEvent.COMPLETE) { return }
                    var data = [String: Any]()
                    data["localPath"] = destinationFile
                    data["url"] = url?.absoluteString
                    self.sendEvent(name: StorageEvent.COMPLETE,
                                   value: StorageEvent(eventId: asId, data: data).toJSONString())
                }
            }
            
            downloadTask.observe(.progress) { snapshot in
                if let p = snapshot.progress, p.totalUnitCount > 0 {
                    if !self.hasEventListener(asId: asId, type: StorageProgressEvent.PROGRESS) { return }
                    self.sendEvent(name: StorageProgressEvent.PROGRESS,
                                   value: StorageProgressEvent(eventId: asId,
                                                               bytesLoaded: Double(p.completedUnitCount),
                                                               bytesTotal: Double(p.totalUnitCount)).toJSONString()
                    )
                }
            }
            
            downloadTask.observe(.failure, handler: {snapshot in
                if let err = snapshot.error as NSError? {
                    if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                    self.sendEvent(name: StorageErrorEvent.ERROR,
                                   value: StorageErrorEvent(eventId: asId,
                                                                 text: err.localizedDescription,
                                                                 id: err.code).toJSONString())
                }
            })
            
            downloadTasks[asId] = downloadTask
        }
    }
    
    func getParent(path: String) -> StorageReference? {
        return storage?.reference(withPath: path).parent()
    }
    
    func getRoot(path: String) -> StorageReference? {
        return storage?.reference(withPath: path).root()
    }
    
    func deleteReference(path: String, asId: String) {
        storage?.reference(withPath: path).delete(completion: { error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: StorageEvent.COMPLETE) { return }
                self.sendEvent(name: StorageEvent.COMPLETE,
                               value: StorageEvent(eventId: asId, data: ["localPath": path]).toJSONString())
            }
        })
    }
    
    func putBytes(path: String, asId: String, bytes: NSData, metadata: StorageMetadata?) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        let uploadTask = storageRef.putData(bytes as Data, metadata: metadata)
        
        uploadTask.observe(.failure, handler: {snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        uploadTask.observe(.progress) { snapshot in
            if let p = snapshot.progress, p.totalUnitCount > 0 {
                if !self.hasEventListener(asId: asId, type: StorageProgressEvent.PROGRESS) { return }
                self.sendEvent(name: StorageProgressEvent.PROGRESS,
                               value: StorageProgressEvent(eventId: asId,
                                                           bytesLoaded: Double(p.completedUnitCount),
                                                           bytesTotal: Double(p.totalUnitCount)).toJSONString()
                )
            }
        }
        
        uploadTask.observe(.success, handler: { _ in
            if !self.hasEventListener(asId: asId, type: StorageEvent.COMPLETE) { return }
            self.sendEvent(name: StorageEvent.COMPLETE,
                           value: StorageEvent(eventId: asId, data: nil).toJSONString())
        })
        
        uploadTasks[asId] = uploadTask
    
    }
    
    func putFile(path: String, asId: String, filePath: String, metadata: StorageMetadata?) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        let localFile = URL(fileURLWithPath: filePath)
        
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        uploadTask.observe(.progress) { snapshot in
            if let p = snapshot.progress, p.totalUnitCount > 0 {
                if !self.hasEventListener(asId: asId, type: StorageProgressEvent.PROGRESS) { return }
                self.sendEvent(name: StorageProgressEvent.PROGRESS,
                               value: StorageProgressEvent(eventId: asId,
                                                                bytesLoaded: Double(p.completedUnitCount),
                                                                bytesTotal: Double(p.totalUnitCount)).toJSONString())
            }
        }
        
        uploadTask.observe(.failure, handler: {snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        uploadTask.observe(.success, handler: { _ in
            var data = [String: Any]()
            data["localPath"] = filePath
            // TODO return metaData
            if !self.hasEventListener(asId: asId, type: StorageEvent.COMPLETE) { return }
            self.sendEvent(name: StorageEvent.COMPLETE,
                           value: StorageEvent(eventId: asId, data: data).toJSONString())
        })
        
        uploadTasks[asId] = uploadTask
        
    }
    
    func getBytes(path: String, maxDownloadSizeBytes: Int?, asId: String) {
        guard let storageRef = storage?.reference(withPath: path) else {return}
        let ONE_MEGABYTE: Int = 1024 * 1024
        
        var _maxDownloadSizeBytes: Int = ONE_MEGABYTE
        if let mdsb = maxDownloadSizeBytes, mdsb > 0 {
            _maxDownloadSizeBytes = mdsb
        }
        
        let downloadTask = storageRef.getData(maxSize: Int64(_maxDownloadSizeBytes), completion: { data, error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                        text: err.localizedDescription,
                                                        id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: StorageEvent.COMPLETE) { return }
                if let data = data {
                    let b64 = data.base64EncodedString(options: .init(rawValue: 0))
                    self.sendEvent(name: StorageEvent.COMPLETE,
                                   value: StorageEvent(eventId: asId, data: ["b64": b64]).toJSONString())
                }
            }
        })
        
        downloadTask.observe(.failure, handler: { snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        downloadTasks[asId] = downloadTask
        
    }
    
    func getMetadata(path: String, asId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        
        storageRef.getMetadata { metadata, error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: StorageEvent.GET_METADATA) { return }
                if let m = metadata {
                    var data = [String: Any]()
                    data["bucket"] = m.bucket
                    data["cacheControl"] = m.cacheControl
                    data["contentDisposition"] = m.contentDisposition
                    data["contentEncoding"] = m.contentEncoding
                    data["contentLanguage"] = m.contentLanguage
                    data["contentType"] = m.contentType
                    if let timeCreated = m.timeCreated {
                        data["creationTime"] = timeCreated.timeIntervalSince1970 * 1000
                    }
                    if let updatedTime = m.updated {
                        data["updatedTime"] = updatedTime.timeIntervalSince1970 * 1000
                    }
                    data["generation"] = m.generation
                    data["metadataGeneration"] = m.metageneration
                    data["name"] = m.name
                    data["path"] = m.path
                    data["size"] = m.size
                    data["customMetadata"] = m.customMetadata
                    self.sendEvent(name: StorageEvent.GET_METADATA,
                                   value: StorageEvent(eventId: asId,
                                                            data: ["data": data]).toJSONString())
                    
                }
            }
        }
    }
    
    func getDownloadUrl(path: String, asId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.downloadURL(completion: {(url, error) in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            } else {
                if let u = url?.absoluteString {
                    if !self.hasEventListener(asId: asId, type: StorageEvent.GET_DOWNLOAD_URL) { return }
                    self.sendEvent(name: StorageEvent.GET_DOWNLOAD_URL,
                                   value: StorageEvent(eventId: asId,
                                                            data: ["url": u]).toJSONString())
                }
                
            }
        })
    }
    
    func updateMetadata(path: String, asId: String, metadata: StorageMetadata) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.updateMetadata(metadata, completion: { _, error in
            if let err = error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.sendEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: StorageEvent.UPDATE_METADATA) { return }
                self.sendEvent(name: StorageEvent.UPDATE_METADATA,
                               value: StorageEvent(eventId: asId, data: nil).toJSONString())
                
            }
        })
    }
    
    // MARK: - Tasks
    
    func resumeTask(asId: String) {
        uploadTasks[asId]?.resume()
        downloadTasks[asId]?.resume()
    }
    
    func pauseTask(asId: String) {
        uploadTasks[asId]?.pause()
        downloadTasks[asId]?.pause()
    }
    
    func cancelTask(asId: String) {
        uploadTasks[asId]?.cancel()
        downloadTasks[asId]?.cancel()
    }
    
    // MARK: - Getters / Setters
    
    public var maxDownloadRetryTime: TimeInterval {
        get {
            if let ret = storage?.maxDownloadRetryTime {
                return ret * 1000
            }
            return 0.0
        }
        set {
            storage?.maxDownloadRetryTime = newValue / 1000
        }
        
    }
    
    public var maxUploadRetryTime: TimeInterval {
        get {
            if let ret = storage?.maxUploadRetryTime {
                return ret * 1000
            }
            return 0.0
        }
        set {
            storage?.maxUploadRetryTime = newValue / 1000
        }
    }
    
    public var maxOperationRetryTime: TimeInterval {
        get {
            if let ret = storage?.maxOperationRetryTime {
                return ret * 1000
            }
            return 0.0
        }
        set {
            storage?.maxOperationRetryTime = newValue / 1000
        }
    }
    
    // MARK: - AS Event Listeners
    
    func addEventListener(asId: String, type: String) {
        listeners.append(Listener(asId: asId, type: type))
    }
    
    func removeEventListener(asId: String, type: String) {
        for i in 0..<listeners.count {
            if listeners[i].asId == asId && listeners[i].type == type {
                listeners.remove(at: i)
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
