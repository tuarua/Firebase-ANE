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

class StorageEvent: NSObject {
    public static let GET_DOWNLOAD_URL = "StorageEvent.GetDownloadUrl"
    public static let GET_METADATA = "StorageEvent.GetMetadata"
    public static let UPDATE_METADATA = "StorageEvent.UpdateMetadata"
    public static let TASK_COMPLETE = "StorageEvent.TaskComplete"
    public static let DELETED = "StorageEvent.Deleted"
    
    var eventId: String?
    var data: [String: Any]?
    var error: NSError?
 
    convenience init(eventId: String?, data: [String: Any]? = nil, error: NSError? = nil) {
        self.init()
        self.eventId = eventId
        self.data = data
        self.error = error
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["eventId"] = eventId
        props["data"] = data
        props["error"] = error?.toDictionary()
        return JSON(props).description
    }
}
