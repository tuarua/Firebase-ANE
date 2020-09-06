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
import FreSwift
import OneSignal

public extension OSNotificationOpenedResult {
    func toDictionary() -> [String: Any] {
        var ret = [String: Any]()
        ret["actionID"] = action.actionID
        ret["additionalUserInfo"] = action.type.rawValue
        ret["action"] = [
            "actionID": action.actionID ?? "",
            "type": action.type.rawValue
        ]
        ret["notification"] = notification.toDictionary()
        return ret
    }
}
