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

class RemoteConfigErrorEvent: NSObject {
    public static let FETCH_ERROR = "RemoteConfigErrorEvent.FetchError"
    public static let ACTIVATE_ERROR = "RemoteConfigErrorEvent.ActivateError"
    var callbackId: String?
    var text: String?
    var id: Int = 0
    
    convenience init(callbackId: String?, text: String?, id: Int = 0) {
        self.init()
        self.callbackId = callbackId
        self.text = text
        self.id = id
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["callbackId"] = callbackId
        props["text"] = text
        props["id"] = id
        return JSON(props).description
    }
}
