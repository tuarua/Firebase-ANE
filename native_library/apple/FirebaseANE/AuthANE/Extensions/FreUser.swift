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
import FreSwift
import Foundation
import FirebaseAuth

public extension User {
    func toFREObject() -> FREObject? {
        return FREObject.init(className: "com.tuarua.firebase.auth.FirebaseUser",
                                  args: uid,
                                  displayName,
                                  email,
                                  isAnonymous,
                                  isEmailVerified,
                                  photoURL?.absoluteString,
                                  phoneNumber)
    }
    @objc func toDictionary() -> [String: Any] {
        var ret = [String: Any]()
        ret["uid"] = uid
        ret["displayName"] = displayName
        ret["email"] = email
        ret["isAnonymous"] = isAnonymous
        ret["isEmailVerified"] = isEmailVerified
        ret["photoUrl"] = photoURL?.absoluteString
        ret["phoneNumber"] = phoneNumber
        return ret
    }
}

/*
 "uid" to uid,
 "displayName" to displayName,
 "email" to email,
 "isAnonymous" to isAnonymous,
 "isEmailVerified" to isEmailVerified,
 "photoUrl" to photoUrl.toString(),
 "phoneNumber" to phoneNumber
 */
