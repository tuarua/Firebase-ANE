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

class AuthErrorEvent: NSObject {
    public static let SIGN_IN_ERROR: String = "AuthErrorEvent.SignInError"
    public static let SIGN_OUT_ERROR: String = "AuthErrorEvent.SignOutError"
    public static let USER_DELETED_ERROR: String = "AuthErrorEvent.UserDeletedError"
    public static let USER_REAUTHENTICATED_ERROR: String = "AuthErrorEvent.UserReauthenticatedError"
    public static let USER_CREATED_ERROR: String = "AuthErrorEvent.UserCreatedError"
    public static let PASSWORD_RESET_EMAIL_SENT_ERROR: String = "AuthErrorEvent.PasswordResetEmailSentError"
    public static let EMAIL_VERIFICATION_SENT_ERROR: String = "AuthErrorEvent.EmailVerificationSentError"
    
    var text: String?
    var id: Int = 0
    
    convenience init(text: String?, id: Int = 0) {
        self.init()
        self.text = text
        self.id = id
    }
    
    public func toJSONString() -> String {
        var props = [String: Any]()
        props["text"] = text
        props["id"] = id
        let json = JSON(props)
        return json.description
    }
}
