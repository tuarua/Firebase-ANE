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

class DocumentEvent: NSObject {
    public static let SNAPSHOT = "DocumentEvent.Snapshot"
    public static let QUERY_SNAPSHOT = "QueryEvent.QuerySnapshot"
    public static let UPDATED = "DocumentEvent.Updated"
    public static let SET = "DocumentEvent.Set"
    public static let DELETED = "DocumentEvent.Deleted"
    
    var callbackId: String?
    var data: [String: Any]?
    var realtime: Bool = false
    var error: NSError?

    convenience init(callbackId: String?, data: [String: Any]? = nil,
                     realtime: Bool = false,
                     error: NSError? = nil) {
        self.init()
        self.callbackId = callbackId
        self.data = data
        self.realtime = realtime
        self.error = error
    }

    public func toJSONString() -> String {
        var props = [String: Any]()
        props["callbackId"] = callbackId
        props["data"] = data
        props["realtime"] = realtime
        props["error"] = error?.toDictionary()
        return JSON(props).description
    }

}
