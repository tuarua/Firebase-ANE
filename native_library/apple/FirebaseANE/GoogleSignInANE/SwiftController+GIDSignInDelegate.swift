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
            self.dispatchEvent(name: GoogleSignInEvent.ERROR,
                           value: GoogleSignInEvent(data: ["text": err.localizedDescription,
                                                           "id": err.code]).toJSONString())
        } else {
            guard let authentication = user.authentication else { return }
            self.dispatchEvent(name: GoogleSignInEvent.SIGN_IN,
                               value: GoogleSignInEvent(data: ["idToken": authentication.idToken ?? "",
                                                               "accessToken": authentication.accessToken
                                                                ?? ""]).toJSONString())
        }
        
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        if let app = FirebaseApp.app() {
            hasFirebaseApp = true
            GIDSignIn.sharedInstance().clientID = app.options.clientID
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().uiDelegate = self
        }
        
    }
    
}
