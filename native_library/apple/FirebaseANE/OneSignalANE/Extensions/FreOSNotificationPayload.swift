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

public extension OSNotificationPayload {
    func toDictionary() -> [String: Any] {
        var ret = [String: Any]()
        ret["notificationID"] = notificationID
        ret["title"] = title
        ret["body"] = body
        ret["additionalData"] = additionalData
        ret["launchURL"] = launchURL
        ret["sound"] = sound
        var actionButtons = [[String: Any]]()
        for button in actionButtons {
            var d = [String: Any]()
            d["id"] = button["id"]
            d["text"] = button["text"]
            d["icon"] = button["icon"]
            actionButtons.append(d)
        }
        ret["actionButtons"] = actionButtons
        ret["rawPayload"] = rawPayload
        
        // iOS only
        ret["badge"] = badge
        ret["badgeIncrement"] = badgeIncrement
        ret["attachments"] = attachments
        ret["category"] = category
        ret["contentAvailable"] = contentAvailable
        ret["mutableContent"] = mutableContent
        ret["subtitle"] = subtitle
        ret["templateID"] = templateID
        ret["templateName"] = templateName
        return ret
    }
}
