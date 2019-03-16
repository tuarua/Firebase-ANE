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

import FreSwift
import Foundation
import Firebase
import FirebaseStorage

class StorageController: FreSwiftController {
    static var TAG = "StorageController"
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
                    self.dispatchEvent(name: StorageErrorEvent.ERROR,
                                   value: StorageErrorEvent(eventId: asId,
                                                            text: err.localizedDescription,
                                                            id: err.code).toJSONString())
                } else {
                    if !self.hasEventListener(asId: asId, type: StorageEvent.TASK_COMPLETE) { return }
                    var data = [String: Any]()
                    data["localPath"] = destinationFile
                    data["url"] = url?.absoluteString
                    self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                                   value: StorageEvent(eventId: asId, data: data).toJSONString())
                }
            }
            
            downloadTask.observe(.progress) { snapshot in
                if let p = snapshot.progress, p.totalUnitCount > 0 {
                    if !self.hasEventListener(asId: asId, type: StorageProgressEvent.PROGRESS) { return }
                    self.dispatchEvent(name: StorageProgressEvent.PROGRESS,
                                   value: StorageProgressEvent(eventId: asId,
                                                               bytesLoaded: Double(p.completedUnitCount),
                                                               bytesTotal: Double(p.totalUnitCount)).toJSONString()
                    )
                }
            }
            
            downloadTask.observe(.failure, handler: { snapshot in
                if let err = snapshot.error as NSError? {
                    if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                    self.dispatchEvent(name: StorageErrorEvent.ERROR,
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
    
    func deleteReference(path: String, eventId: String?) {
        storage?.reference(withPath: path).delete(completion: { error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: eventId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            } else {
                self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                               value: StorageEvent(eventId: eventId, data: ["localPath": path]).toJSONString())
            }
        })
    }
    
    func putBytes(path: String, asId: String, bytes: NSData, metadata: StorageMetadata?) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        let uploadTask = storageRef.putData(bytes as Data, metadata: metadata)
        
        uploadTask.observe(.failure, handler: {snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        uploadTask.observe(.progress) { snapshot in
            if let p = snapshot.progress, p.totalUnitCount > 0 {
                if !self.hasEventListener(asId: asId, type: StorageProgressEvent.PROGRESS) { return }
                self.dispatchEvent(name: StorageProgressEvent.PROGRESS,
                               value: StorageProgressEvent(eventId: asId,
                                                           bytesLoaded: Double(p.completedUnitCount),
                                                           bytesTotal: Double(p.totalUnitCount)).toJSONString()
                )
            }
        }
        
        uploadTask.observe(.success, handler: { _ in
            if !self.hasEventListener(asId: asId, type: StorageEvent.TASK_COMPLETE) { return }
            self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                           value: StorageEvent(eventId: asId, data: nil).toJSONString())
            self.uploadTasks[asId] = nil
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
                self.dispatchEvent(name: StorageProgressEvent.PROGRESS,
                               value: StorageProgressEvent(eventId: asId,
                                                                bytesLoaded: Double(p.completedUnitCount),
                                                                bytesTotal: Double(p.totalUnitCount)).toJSONString())
            }
        }
        
        uploadTask.observe(.failure, handler: {snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        uploadTask.observe(.success, handler: { _ in
            var data = [String: Any]()
            data["localPath"] = filePath
            if !self.hasEventListener(asId: asId, type: StorageEvent.TASK_COMPLETE) { return }
            self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                           value: StorageEvent(eventId: asId, data: data).toJSONString())
            self.uploadTasks[asId] = nil
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
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                        text: err.localizedDescription,
                                                        id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(asId: asId, type: StorageEvent.TASK_COMPLETE) { return }
                if let data = data {
                    let b64 = data.base64EncodedString(options: .init(rawValue: 0))
                    self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                                   value: StorageEvent(eventId: asId, data: ["b64": b64]).toJSONString())
                }
                self.downloadTasks[asId] = nil
            }
        })
        
        downloadTask.observe(.failure, handler: { snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(asId: asId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(eventId: asId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        downloadTasks[asId] = downloadTask
        
    }
    
    func getMetadata(path: String, eventId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.getMetadata { metadata, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageEvent.GET_METADATA,
                               value: StorageEvent(eventId: eventId,
                                                   data: nil,
                                                   error: err).toJSONString())
                
            } else {
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
                    
                    self.dispatchEvent(name: StorageEvent.GET_METADATA,
                                   value: StorageEvent(eventId: eventId,
                                                            data: ["data": data]).toJSONString())
                    
                }
            }
        }
    }
    
    func getDownloadUrl(path: String, eventId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.downloadURL(completion: { url, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageEvent.GET_DOWNLOAD_URL,
                               value: StorageEvent(eventId: eventId,
                                                   data: nil,
                                                   error: err).toJSONString())
                
            } else {
                if let u = url?.absoluteString {
                    self.dispatchEvent(name: StorageEvent.GET_DOWNLOAD_URL,
                                   value: StorageEvent(eventId: eventId,
                                                            data: ["url": u]).toJSONString())
                }
                
            }
        })
    }
    
    func updateMetadata(path: String, eventId: String?, metadata: StorageMetadata) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.updateMetadata(metadata, completion: { _, error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageEvent.UPDATE_METADATA,
                               value: StorageEvent(eventId: eventId, 
                                                   error: err).toJSONString())
                
            } else { 
                self.dispatchEvent(name: StorageEvent.UPDATE_METADATA,
                               value: StorageEvent(eventId: eventId).toJSONString())
                
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
