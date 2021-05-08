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
import Firebase
import GoogleSignIn

extension SwiftController: GIDSignInDelegate {
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error as NSError? {
            dispatchEvent(name: GoogleSignInEvent.ERROR, value: GoogleSignInEvent(data: [
                "text": err.localizedDescription,
                "id": err.code
            ]).toJSONString())
        } else {
            let authentication = user.authentication
            let profile = user.profile
            let photoUrl = profile?.hasImage ?? false
                    ? profile!.imageURL(withDimension: 512).absoluteString
                    : nil
            dispatchEvent(name: GoogleSignInEvent.SIGN_IN, value: GoogleSignInEvent(data: [
                "id": user.userID as Any,
                "grantedScopes": user.grantedScopes as Any,
                "serverAuthCode": user.serverAuthCode as Any,
                "idToken": authentication?.idToken as Any,
                "accessToken": authentication?.accessToken as Any,
                "email": profile?.email as Any,
                "displayName": profile?.name as Any,
                "familyName": profile?.familyName as Any,
                "givenName": profile?.givenName as Any,
                "photoUrl": photoUrl as Any
            ]).toJSONString())
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        if let app = FirebaseApp.app() {
            hasFirebaseApp = true
            GIDSignIn.sharedInstance().clientID = app.options.clientID
            GIDSignIn.sharedInstance().delegate = self
        }
        
    }
    
}
