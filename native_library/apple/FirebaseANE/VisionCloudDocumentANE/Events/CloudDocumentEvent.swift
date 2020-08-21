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

class CloudDocumentEvent: NSObject {
    public static let RECOGNIZED = "CloudDocumentEvent.Recognized"
    var callbackId: String?
    var error: NSError?
    
    convenience init(callbackId: String?, error: NSError? = nil) {
        self.init()
        self.callbackId = callbackId
        self.error = error
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["callbackId"] = callbackId
        props["error"] = error?.toDictionary()
        return JSON(props).description
    }
}
