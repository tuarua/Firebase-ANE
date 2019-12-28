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
        var callbackId: String
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
    
    func getFile(path: String, destinationFile: String, callbackId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        if let localURL = URL(string: destinationFile) {
            let downloadTask = storageRef.write(toFile: localURL) { url, error in
                if let err = error as NSError? {
                    if !self.hasEventListener(callbackId: callbackId, type: StorageErrorEvent.ERROR) { return }
                    self.dispatchEvent(name: StorageErrorEvent.ERROR,
                                   value: StorageErrorEvent(callbackId: callbackId,
                                                            text: err.localizedDescription,
                                                            id: err.code).toJSONString())
                } else {
                    if !self.hasEventListener(callbackId: callbackId, type: StorageEvent.TASK_COMPLETE) { return }
                    var data = [String: Any]()
                    data["localPath"] = destinationFile
                    data["url"] = url?.absoluteString
                    self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                                   value: StorageEvent(callbackId: callbackId, data: data).toJSONString())
                }
            }
            
            downloadTask.observe(.progress) { snapshot in
                if let p = snapshot.progress, p.totalUnitCount > 0 {
                    if !self.hasEventListener(callbackId: callbackId, type: StorageProgressEvent.PROGRESS) { return }
                    self.dispatchEvent(name: StorageProgressEvent.PROGRESS,
                                   value: StorageProgressEvent(callbackId: callbackId,
                                                               bytesLoaded: Double(p.completedUnitCount),
                                                               bytesTotal: Double(p.totalUnitCount)).toJSONString()
                    )
                }
            }
            
            downloadTask.observe(.failure, handler: { snapshot in
                if let err = snapshot.error as NSError? {
                    if !self.hasEventListener(callbackId: callbackId, type: StorageErrorEvent.ERROR) { return }
                    self.dispatchEvent(name: StorageErrorEvent.ERROR,
                                   value: StorageErrorEvent(callbackId: callbackId,
                                                                 text: err.localizedDescription,
                                                                 id: err.code).toJSONString())
                }
            })
            
            downloadTasks[callbackId] = downloadTask
        }
    }
    
    func getParent(path: String) -> StorageReference? {
        return storage?.reference(withPath: path).parent()
    }
    
    func getRoot(path: String) -> StorageReference? {
        return storage?.reference(withPath: path).root()
    }
    
    func deleteReference(path: String, callbackId: String?) {
        storage?.reference(withPath: path).delete(completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(callbackId: callbackId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            } else {
                self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                               value: StorageEvent(callbackId: callbackId, data: ["localPath": path]).toJSONString())
            }
        })
    }
    
    func putBytes(path: String, callbackId: String, bytes: NSData, metadata: StorageMetadata?) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        let uploadTask = storageRef.putData(bytes as Data, metadata: metadata)
        
        uploadTask.observe(.failure, handler: {snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(callbackId: callbackId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(callbackId: callbackId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        uploadTask.observe(.progress) { snapshot in
            if let p = snapshot.progress, p.totalUnitCount > 0 {
                if !self.hasEventListener(callbackId: callbackId, type: StorageProgressEvent.PROGRESS) { return }
                self.dispatchEvent(name: StorageProgressEvent.PROGRESS,
                               value: StorageProgressEvent(callbackId: callbackId,
                                                           bytesLoaded: Double(p.completedUnitCount),
                                                           bytesTotal: Double(p.totalUnitCount)).toJSONString()
                )
            }
        }
        
        uploadTask.observe(.success, handler: { _ in
            if !self.hasEventListener(callbackId: callbackId, type: StorageEvent.TASK_COMPLETE) { return }
            self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                           value: StorageEvent(callbackId: callbackId, data: nil).toJSONString())
            self.uploadTasks[callbackId] = nil
        })
        
        uploadTasks[callbackId] = uploadTask
    
    }
    
    func putFile(path: String, callbackId: String, filePath: String, metadata: StorageMetadata?) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        let localFile = URL(fileURLWithPath: filePath)
        
        let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        uploadTask.observe(.progress) { snapshot in
            if let p = snapshot.progress, p.totalUnitCount > 0 {
                if !self.hasEventListener(callbackId: callbackId, type: StorageProgressEvent.PROGRESS) { return }
                self.dispatchEvent(name: StorageProgressEvent.PROGRESS,
                               value: StorageProgressEvent(callbackId: callbackId,
                                                                bytesLoaded: Double(p.completedUnitCount),
                                                                bytesTotal: Double(p.totalUnitCount)).toJSONString())
            }
        }
        
        uploadTask.observe(.failure, handler: {snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(callbackId: callbackId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(callbackId: callbackId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        uploadTask.observe(.success, handler: { _ in
            var data = [String: Any]()
            data["localPath"] = filePath
            if !self.hasEventListener(callbackId: callbackId, type: StorageEvent.TASK_COMPLETE) { return }
            self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                           value: StorageEvent(callbackId: callbackId, data: data).toJSONString())
            self.uploadTasks[callbackId] = nil
        })
        
        uploadTasks[callbackId] = uploadTask
        
    }
    
    func getBytes(path: String, maxDownloadSizeBytes: Int?, callbackId: String) {
        guard let storageRef = storage?.reference(withPath: path) else {return}
        let ONE_MEGABYTE: Int = 1024 * 1024
        
        var _maxDownloadSizeBytes: Int = ONE_MEGABYTE
        if let mdsb = maxDownloadSizeBytes, mdsb > 0 {
            _maxDownloadSizeBytes = mdsb
        }
        
        let downloadTask = storageRef.getData(maxSize: Int64(_maxDownloadSizeBytes), completion: { data, error in
            if let err = error as NSError? {
                if !self.hasEventListener(callbackId: callbackId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(callbackId: callbackId,
                                                        text: err.localizedDescription,
                                                        id: err.code).toJSONString())
            } else {
                if !self.hasEventListener(callbackId: callbackId, type: StorageEvent.TASK_COMPLETE) { return }
                if let data = data {
                    let b64 = data.base64EncodedString(options: .init(rawValue: 0))
                    self.dispatchEvent(name: StorageEvent.TASK_COMPLETE,
                                   value: StorageEvent(callbackId: callbackId, data: ["b64": b64]).toJSONString())
                }
                self.downloadTasks[callbackId] = nil
            }
        })
        
        downloadTask.observe(.failure, handler: { snapshot in
            if let err = snapshot.error as NSError? {
                if !self.hasEventListener(callbackId: callbackId, type: StorageErrorEvent.ERROR) { return }
                self.dispatchEvent(name: StorageErrorEvent.ERROR,
                               value: StorageErrorEvent(callbackId: callbackId,
                                                             text: err.localizedDescription,
                                                             id: err.code).toJSONString())
            }
        })
        
        downloadTasks[callbackId] = downloadTask
        
    }
    
    func getMetadata(path: String, callbackId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.getMetadata { metadata, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageEvent.GET_METADATA,
                               value: StorageEvent(callbackId: callbackId,
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
                                   value: StorageEvent(callbackId: callbackId,
                                                            data: ["data": data]).toJSONString())
                    
                }
            }
        }
    }
    
    func getDownloadUrl(path: String, callbackId: String) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.downloadURL(completion: { url, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageEvent.GET_DOWNLOAD_URL,
                               value: StorageEvent(callbackId: callbackId,
                                                   data: nil,
                                                   error: err).toJSONString())
                
            } else {
                if let u = url?.absoluteString {
                    self.dispatchEvent(name: StorageEvent.GET_DOWNLOAD_URL,
                                   value: StorageEvent(callbackId: callbackId,
                                                            data: ["url": u]).toJSONString())
                }
                
            }
        })
    }
    
    func updateMetadata(path: String, callbackId: String?, metadata: StorageMetadata) {
        guard let storageRef = storage?.reference(withPath: path) else { return }
        storageRef.updateMetadata(metadata, completion: { _, error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: StorageEvent.UPDATE_METADATA,
                               value: StorageEvent(callbackId: callbackId,
                                                   error: err).toJSONString())
                
            } else { 
                self.dispatchEvent(name: StorageEvent.UPDATE_METADATA,
                               value: StorageEvent(callbackId: callbackId).toJSONString())
                
            }
        })
    }
    
    // MARK: - Tasks
    
    func resumeTask(callbackId: String) {
        uploadTasks[callbackId]?.resume()
        downloadTasks[callbackId]?.resume()
    }
    
    func pauseTask(callbackId: String) {
        uploadTasks[callbackId]?.pause()
        downloadTasks[callbackId]?.pause()
    }
    
    func cancelTask(callbackId: String) {
        uploadTasks[callbackId]?.cancel()
        downloadTasks[callbackId]?.cancel()
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
    
    func addEventListener(callbackId: String, type: String) {
        listeners.append(Listener(callbackId: callbackId, type: type))
    }
    
    func removeEventListener(callbackId: String, type: String) {
        for i in 0..<listeners.count {
            if listeners[i].callbackId == callbackId && listeners[i].type == type {
                listeners.remove(at: i)
                return
            }
        }
    }
    
    private func hasEventListener(callbackId: String, type: String) -> Bool {
        for i in 0..<listeners.count {
            if listeners[i].callbackId == callbackId && listeners[i].type == type {
                return true
            }
        }
        return false
    }
    
}
