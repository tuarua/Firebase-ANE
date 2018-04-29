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

class AuthEvent: NSObject {
    public static let SIGN_IN: String = "AuthEvent.SignIn"
    public static let PASSWORD_RESET_EMAIL_SENT: String = "AuthEvent.PasswordResetEmailSent"
    public static let USER_DELETED: String = "AuthEvent.UserDeleted"
    public static let USER_REAUTHENTICATED: String = "AuthEvent.UserReauthenticated"
    public static let USER_CREATED: String = "AuthEvent.UserCreated"
    public static let EMAIL_VERIFICATION_SENT: String = "AuthEvent.EmailVerificationSent"
    
    var eventId: String?
    var data: [String: Any]?
    
    convenience init(eventId: String?, data: [String: Any]?) {
        self.init()
        self.eventId = eventId
        self.data = data
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["eventId"] = eventId
        props["data"] = data
        let json = JSON(props)
        return json.description
    }
}
