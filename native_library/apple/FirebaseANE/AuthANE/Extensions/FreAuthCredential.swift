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

extension AuthCredential {
    static func fromFREObject(_ freObject: FREObject?) -> AuthCredential? {
        guard let rv = freObject,
            let provider = String(rv["provider"])
            else { return nil }
        
        let param0 = String(rv["param0"])
        let param1 = String(rv["param1"])
        
        if provider == GoogleAuthProviderID, let p0 = param0, let p1 = param1 {
            return GoogleAuthProvider.credential(withIDToken: p0, accessToken: p1)
        } else if provider == TwitterAuthProviderID, let p0 = param0, let p1 = param1 {
            return TwitterAuthProvider.credential(withToken: p0, secret: p1)
        } else if provider == GitHubAuthProviderID, let p0 = param0 {
            return GitHubAuthProvider.credential(withToken: p0)
        } else if provider == FacebookAuthProviderID, let p0 = param0 {
            return FacebookAuthProvider.credential(withAccessToken: p0)
        } else if provider == EmailAuthProviderID, let p0 = param0, let p1 = param1 {
            return EmailAuthProvider.credential(withEmail: p0, password: p1)
        }
        
        return nil
    }
}
