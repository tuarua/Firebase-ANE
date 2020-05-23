/*
 *  Copyright 2020 Tua Rua Ltd.
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

class OneSignalEvent: NSObject {
    public static let ON_SET_EXTERNAL_USERID = "OneSignalEvent.OnSetExternalUserId"
    public static let ON_REMOVE_EXTERNAL_USERID = "OneSignalEvent.OnRemoveExternalUserId"
    public static let ON_POST_NOTIFICATION_SUCCESS = "OneSignalEvent.OnPostNotificationSuccess"
    public static let ON_POST_NOTIFICATION_FAILURE = "OneSignalEvent.OnPostNotificationFailure"
    public static let ON_GET_TAGS = "OneSignalEvent.OnGetTags"
    public static let ON_SET_EMAIL_SUCCESS = "OneSignalEvent.OnSetEmailSuccess"
    public static let ON_SET_EMAIL_FAILURE = "OneSignalEvent.OnSetEmailFailure"
    
    var callbackId: String?
    var data: [String: Any]?
    var error: NSError?
    
    convenience init(callbackId: String? = nil, data: [String: Any]? = nil, error: NSError? = nil) {
        self.init()
        self.callbackId = callbackId
        self.data = data
        self.error = error
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["callbackId"] = callbackId
        props["data"] = data
        props["error"] = error?.toDictionary()
        return JSON(props).description
    }
}
