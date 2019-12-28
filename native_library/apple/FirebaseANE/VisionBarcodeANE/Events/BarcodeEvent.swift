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

class BarcodeEvent: NSObject {
    public static let DETECTED = "BarcodeEvent.Detected"
    var callbackId: String?
    var error: NSError?
    var continuous: Bool = false
    
    convenience init(callbackId: String?, error: NSError? = nil, continuous: Bool = false) {
        self.init()
        self.callbackId = callbackId
        self.error = error
        self.continuous = continuous
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["callbackId"] = callbackId
        props["error"] = error?.toDictionary()
        props["continuous"] = continuous
        return JSON(props).description
    }
}
