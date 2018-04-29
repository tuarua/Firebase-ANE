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
import FreSwift
import Firebase
import FirebaseAuth

class AuthController: FreSwiftController {
    var TAG: String? = "AuthController"
    internal var context: FreContextSwift!
    private var app: FirebaseApp?
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
        //app = FreFirebase.getFirebaseApp()
    }
    
    func createUser(email: String, password: String) {
        guard let app = app else { return }
        let auth = Auth.auth(app: app)
        auth.createUser(withEmail: email, password: password) { (_, error) in
            if let err = error as NSError? {
                self.sendEvent(name: AuthErrorEvent.USER_CREATED_ERROR,
                               value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_CREATED, value: "") //TODO send back userId or something
            }
            
        }
    }
    
    func signIn(email: String, password: String) {
        guard let app = app else { return }
        
        trace("signInWithEmailAndPassword")
        
        let auth = Auth.auth(app: app)
        
        trace("signIn \(email) \(password)")
        
        auth.signIn(withEmail: email, password: password) { (_, error) in
            if let err = error as NSError? {
                self.trace("sign in error")
                self.trace(err.debugDescription)
                self.sendEvent(name: AuthErrorEvent.SIGN_IN_ERROR,
                               value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            } else {
                self.trace("sign in success")
                self.sendEvent(name: AuthEvent.SIGN_IN, value: "")
            }
        }
    }
    
    func signInAnonymously() {
        guard let app = app else { return }
        let auth = Auth.auth(app: app)
        trace("signInAnonymously")
        auth.signInAnonymously { (user, error) in
            if let err = error as NSError? {
                
                self.trace("signInAnonymously error \(err.localizedDescription)")
                
                self.sendEvent(name: AuthErrorEvent.SIGN_IN_ERROR,
                               value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            } else {
                
                self.trace("signInAnonymously success: anon: \(String(describing: user?.isAnonymous))")
                
                self.sendEvent(name: AuthEvent.SIGN_IN, value: "")
            }
        }
    }
    
    func signOut() {
        guard let app = app else { return }
        let auth = Auth.auth(app: app)
        do {
            trace("signout")
            try auth.signOut()
        } catch let err as NSError {
            //AuthErrorCode.accountExistsWithDifferentCredential
            //AuthErrorCode.keychainError
            
            self.sendEvent(name: AuthErrorEvent.SIGN_OUT_ERROR,
                           value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            
            trace("sign out error", err.code, err.localizedDescription)
        } catch {
            
        }
        
    }
    
    func sendPasswordReset(email: String) {
        guard let app = app else { return }
        let auth = Auth.auth(app: app)
        auth.sendPasswordReset(withEmail: email) { error in
            if let err = error as NSError? {
                self.sendEvent(name: AuthErrorEvent.PASSWORD_RESET_EMAIL_SENT_ERROR,
                               value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.PASSWORD_RESET_EMAIL_SENT, value: "")
            }
        }
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let err = error as NSError? {
                self.sendEvent(name: AuthErrorEvent.USER_DELETED_ERROR,
                               value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_DELETED, value: "")
            }
        }
    }
    
    func reauthenticate(email: String, password: String) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential) {error in
            if let err = error as NSError? {
                self.sendEvent(name: AuthErrorEvent.USER_REAUTHENTICATED_ERROR,
                               value: AuthErrorEvent.init(text: err.localizedDescription, id: err.code).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_REAUTHENTICATED, value: "")
            }
        }
    }
    
    func setLanguage(code: String) {
        guard let app = app else { return }
        let auth = Auth.auth(app: app)
        trace("setLanguage", code)
        auth.languageCode = code
    }
    
    func getLanguage() -> String? {
        guard let app = app else { return nil }
        let auth = Auth.auth(app: app)
        trace("getLanguage")
        return auth.languageCode
    }
    
    //
    //    func getIdToken() {
    //
    //    }
    
}
