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
import SwiftyJSON

class DocumentEvent: NSObject {
    public static let SNAPSHOT = "DocumentEvent.Snapshot"
    public static let QUERY_SNAPSHOT = "QueryEvent.QuerySnapshot"
    public static let UPDATED = "DocumentEvent.Updated"
    public static let SET = "DocumentEvent.Set"
    public static let DELETED = "DocumentEvent.Deleted"
    
    var eventId: String?
    var data: [String: Any]?
    var realtime: Bool = false
    var error: [String: Any]?

    convenience init(eventId: String?, data: [String: Any]? = nil,
                     realtime: Bool = false,
                     error: [String: Any]? = nil) {
        self.init()
        self.eventId = eventId
        self.data = data
        self.realtime = realtime
        self.error = error
    }

    public func toJSONString() -> String {
        var props = [String: Any]()
        props["eventId"] = eventId
        props["data"] = data
        props["realtime"] = realtime
        props["error"] = error
        return JSON(props).description
    }

}
