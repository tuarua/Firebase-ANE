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

class AuthEvent: NSObject {
    public static let EMAIL_UPDATED = "AuthEvent.EmailUpdated"
    public static let PASSWORD_UPDATED = "AuthEvent.PasswordUpdated"
    public static let PROFILE_UPDATED = "AuthEvent.ProfileUpdated"
    public static let SIGN_IN = "AuthEvent.SignIn"
    public static let ID_TOKEN = "AuthEvent.OnIdToken"
    public static let PASSWORD_RESET_EMAIL_SENT = "AuthEvent.PasswordResetEmailSent"
    public static let USER_DELETED = "AuthEvent.UserDeleted"
    public static let USER_REAUTHENTICATED = "AuthEvent.UserReauthenticated"
    public static let USER_CREATED = "AuthEvent.UserCreated"
    public static let USER_UNLINKED = "AuthEvent.UserUnlinked"
    public static let USER_LINKED = "AuthEvent.UserLinked"
    public static let USER_RELOADED = "AuthEvent.UserReloaded"
    public static let EMAIL_VERIFICATION_SENT = "AuthEvent.EmailVerificationSent"
    public static let PHONE_CODE_SENT = "AuthEvent.PhoneCodeSent"
    
    var eventId: String?
    var data: [String: Any]?
    var error: NSError?
    
    convenience init(eventId: String?, data: [String: Any]? = nil, error: NSError? = nil) {
        self.init()
        self.eventId = eventId
        self.data = data
        self.error = error
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["eventId"] = eventId
        props["data"] = data
        props["error"] = error?.toDictionary()
        return JSON(props).description
    }
}
