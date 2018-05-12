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
import FirebaseMessaging

extension SwiftController: MessagingDelegate {
    
    // [START refresh_token]
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        if !isInited {
            startToken = fcmToken
        }
        if context == nil { return }
        self.sendEvent(name: MessageEvent.ON_TOKEN_REFRESHED,
                       value: MessageEvent(data: ["token": fcmToken]).toJSONString())
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    public func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    // [END ios_10_data_message]
    
}
