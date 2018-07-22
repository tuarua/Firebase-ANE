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
import UserNotifications

extension SwiftController: UNUserNotificationCenterDelegate {
    // [START ios_10_message_handling]
    // Receive displayed notifications for iOS 10 devices.
    // Called when a notification is delivered to a foreground app.
    @available(iOS 10, *)
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        completionHandler([.alert, .badge, .sound])
        if context == nil { return }
        self.dispatchEvent(name: MessageEvent.ON_MESSAGE_RECEIVED,
                       value: MessageEvent(data: parseUserInfo(userInfo: userInfo)).toJSONString())
    }
    
    @available(iOS 10, *)
    // Called when a notification is delivered to a background app.
    // Called to let your app know which action was selected by the user for a given notification.
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        completionHandler()
        
        if context == nil { return }
        self.dispatchEvent(name: MessageEvent.ON_MESSAGE_RECEIVED,
                       value: MessageEvent(data: parseUserInfo(userInfo: userInfo)).toJSONString())
    }
     
}
