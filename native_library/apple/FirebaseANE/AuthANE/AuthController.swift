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
    static var TAG = "AuthController"
    internal var context: FreContextSwift!
    private var auth: Auth?
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
        guard let app = FirebaseApp.app() else {
            warning(">>>>>>>>>> NO FirebaseApp !!!!!!!!!!!!!!!!!!!!!")
            return
        }
        auth = Auth.auth(app: app)
    }
    
    func createUser(email: String, password: String, callbackId: String?) {
        auth?.createUser(withEmail: email, password: password) { (_, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.USER_CREATED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.USER_CREATED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        }
    }
    
    func signIn(credential: AuthCredential, callbackId: String?) {
        auth?.signIn(with: credential, completion: { (result, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                                   value: AuthEvent(callbackId: callbackId, data: nil,
                                                    error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                               value: AuthEvent(callbackId: callbackId,
                                                data: result?.toDictionary()).toJSONString())
            }
        })
    }
    
    func signIn(provider: OAuthProvider, callbackId: String?) {
        auth?.signIn(with: provider, uiDelegate: nil, completion: { (result, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                                   value: AuthEvent(callbackId: callbackId,
                                                    data: nil,
                                                    error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                               value: AuthEvent(callbackId: callbackId,
                                                data: result?.toDictionary()).toJSONString())
            }
        })
    }
    
    func signInAnonymously(callbackId: String?) {
        auth?.signInAnonymously { (result, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                               value: AuthEvent(callbackId: callbackId, data: nil,
                                                error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                               value: AuthEvent(callbackId: callbackId,
                                                data: result?.toDictionary()).toJSONString())
            }
        }
    }
    
    func signInWithCustomToken(token: String, callbackId: String?) {
        auth?.signIn(withCustomToken: token, completion: { (result, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                               value: AuthEvent(callbackId: callbackId, data: nil,
                                                error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.SIGN_IN,
                               value: AuthEvent(callbackId: callbackId,
                                                data: result?.toDictionary()).toJSONString())
            }
        })
    }
    
    func signOut() {
        do {
            try auth?.signOut()
        } catch {
            
        }
    }
    
    func sendPasswordReset(email: String, callbackId: String?) {
        auth?.sendPasswordReset(withEmail: email) { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.PASSWORD_RESET_EMAIL_SENT,
                               value: AuthEvent(callbackId: callbackId, data: nil,
                                                error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.PASSWORD_RESET_EMAIL_SENT,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        }
    }
    
    func reauthenticate(email: String, password: String, callbackId: String?) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        let user = Auth.auth().currentUser
        user?.reauthenticate(with: credential, completion: { (_, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.USER_REAUTHENTICATED,
                               value: AuthEvent(callbackId: callbackId, data: nil,
                                                error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.USER_REAUTHENTICATED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
    func verifyPhoneNumber(phoneNumber: String, callbackId: String?) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.PHONE_CODE_SENT,
                               value: AuthEvent(callbackId: callbackId, data: nil,
                                                error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.PHONE_CODE_SENT,
                               value: AuthEvent(callbackId: callbackId,
                                                data: ["verificationId": verificationId ?? ""]).toJSONString())
            }
        }
    }
    
    func setLanguage(code: String) {
        auth?.languageCode = code
    }
    
    func getLanguage() -> String? {
        return auth?.languageCode
    }
    
}
