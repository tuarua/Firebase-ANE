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
    var TAG: String? = "FirestoreController"
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
    
    func sendEmailVerification(eventId: String?) {
        let user = Auth.auth().currentUser
        user?.sendEmailVerification { error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.EMAIL_VERIFICATION_SENT,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.EMAIL_VERIFICATION_SENT,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        }
    }
    
    func update(email: String, eventId: String?) {
        let user = Auth.auth().currentUser
        user?.updateEmail(to: email) { error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.EMAIL_UPDATED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.EMAIL_UPDATED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        }
    }
    
    func update(password: String, eventId: String?) {
        let user = Auth.auth().currentUser
        user?.updatePassword(to: password) { error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.PASSWORD_UPDATED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.PASSWORD_UPDATED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        }
    }
    
    func link(credential: AuthCredential, eventId: String?) {
        let user = Auth.auth().currentUser
        user?.linkAndRetrieveData(with: credential, completion: { (_, error) in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.USER_LINKED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_LINKED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        })
    }
    
    func unlink(provider: String, eventId: String?) {
        let user = Auth.auth().currentUser
        user?.unlink(fromProvider: provider) { _, error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.USER_UNLINKED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_UNLINKED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        }
        
    }
    
    func deleteUser(eventId: String?) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.USER_DELETED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_DELETED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        })
    }
    
    func getCurrentUser() -> User? {
        return auth?.currentUser
    }
    
    func updateProfile(displayName: String?, photoUrl: String?, eventId: String?) {
        let user = Auth.auth().currentUser
        let pcr = user?.createProfileChangeRequest()
        pcr?.displayName = displayName
        if let purl = photoUrl {
            pcr?.photoURL = URL(string: purl)
        }
    
        pcr?.commitChanges(completion: { error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.PROFILE_UPDATED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.PROFILE_UPDATED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        })
    }
    
    func reload(eventId: String?) {
        auth?.currentUser?.reload(completion: { error in
            if eventId == nil { return }
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.USER_RELOADED,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.USER_RELOADED,
                               value: AuthEvent(eventId: eventId).toJSONString())
            }
        })
    }
    
    func getIdToken(forceRefresh: Bool, eventId: String) {
        auth?.currentUser?.getIDTokenForcingRefresh(forceRefresh, completion: { token, error in
            if let err = error as NSError? {
                self.sendEvent(name: AuthEvent.ID_TOKEN,
                               value: AuthEvent(eventId: eventId, data: nil,
                                                error: ["text": err.localizedDescription,
                                                        "id": err.code]).toJSONString())
            } else {
                self.sendEvent(name: AuthEvent.ID_TOKEN,
                               value: AuthEvent(eventId: eventId, data: ["token": token ?? ""]).toJSONString())
            }
        })
    }
    
}
