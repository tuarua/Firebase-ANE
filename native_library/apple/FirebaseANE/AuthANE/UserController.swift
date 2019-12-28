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

class UserController: FreSwiftController {
    static var TAG = "FirestoreController"
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
    
    func sendEmailVerification(callbackId: String?) {
        let user = Auth.auth().currentUser
        user?.sendEmailVerification { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.EMAIL_VERIFICATION_SENT,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.EMAIL_VERIFICATION_SENT,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        }
    }
    
    func update(email: String, callbackId: String?) {
        let user = Auth.auth().currentUser
        user?.updateEmail(to: email) { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.EMAIL_UPDATED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.EMAIL_UPDATED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        }
    }
    
    func update(password: String, callbackId: String?) {
        let user = Auth.auth().currentUser
        user?.updatePassword(to: password) { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.PASSWORD_UPDATED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.PASSWORD_UPDATED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        }
    }
    
    func link(credential: AuthCredential, callbackId: String?) {
        let user = Auth.auth().currentUser
        user?.link(with: credential, completion: { (_, error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.USER_LINKED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.USER_LINKED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
    func unlink(provider: String, callbackId: String?) {
        let user = Auth.auth().currentUser
        user?.unlink(fromProvider: provider) { _, error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.USER_UNLINKED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.USER_UNLINKED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        }
        
    }
    
    func deleteUser(callbackId: String?) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.USER_DELETED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.USER_DELETED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
    func getCurrentUser() -> User? {
        return auth?.currentUser
    }
    
    func updateProfile(displayName: String?, photoUrl: String?, callbackId: String?) {
        let user = Auth.auth().currentUser
        let pcr = user?.createProfileChangeRequest()
        pcr?.displayName = displayName
        if let purl = photoUrl {
            pcr?.photoURL = URL(string: purl)
        }
    
        pcr?.commitChanges(completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.PROFILE_UPDATED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.PROFILE_UPDATED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
    func reload(callbackId: String?) {
        auth?.currentUser?.reload(completion: { error in
            if callbackId == nil { return }
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.USER_RELOADED,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.USER_RELOADED,
                               value: AuthEvent(callbackId: callbackId).toJSONString())
            }
        })
    }
    
    func getIdToken(forceRefresh: Bool, callbackId: String) {
        auth?.currentUser?.getIDTokenForcingRefresh(forceRefresh, completion: { token, error in
            if let err = error as NSError? {
                self.dispatchEvent(name: AuthEvent.ID_TOKEN,
                               value: AuthEvent(callbackId: callbackId, data: nil, error: err).toJSONString())
            } else {
                self.dispatchEvent(name: AuthEvent.ID_TOKEN,
                               value: AuthEvent(callbackId: callbackId, data: ["token": token ?? ""]).toJSONString())
            }
        })
    }
    
}
