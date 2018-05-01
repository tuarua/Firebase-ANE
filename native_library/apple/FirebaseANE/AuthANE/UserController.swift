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
    
    func sendEmailVerification() {
        let user = Auth.auth().currentUser
        user?.sendEmailVerification { error in
            self.trace(error.debugDescription)
        }
    }
    
    func update(email: String) {
        let user = Auth.auth().currentUser
        user?.updateEmail(to: email) { error in
            self.trace(error.debugDescription)
        }
    }
    
    func update(password: String) {
        let user = Auth.auth().currentUser
        user?.updatePassword(to: password) { error in
           self.trace(error.debugDescription)
        }
    }
    
    func unlink(provider: String) {
        let user = Auth.auth().currentUser
        user?.unlink(fromProvider: provider) { (_, error) in
            self.trace(error.debugDescription)
        }
        
    }
    
    func getCurrentUser() -> User? {
        return auth?.currentUser
    }
    //
    //    func getIdToken() {
    //
    //    }
    
}
