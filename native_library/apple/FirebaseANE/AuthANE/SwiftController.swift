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
import FirebaseAuth

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    private var authController: AuthController?
    private var userController: UserController?
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        authController = AuthController(context: context)
        userController = UserController(context: context)
        return true.toFREObject()
    }
    
    func createUserWithEmailAndPassword(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let email = String(argv[0]),
            let password = String(argv[1])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[2])
        authController?.createUser(email: email, password: password, callbackId: callbackId)
        return nil
        
    }
    
    func signInWithCredential(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let credential = AuthCredential.fromFREObject(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        authController?.signIn(credential: credential, callbackId: callbackId)
        return nil
    }
    
    func signInWithProvider(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let provider: OAuthProvider = OAuthProvider.fromFREObject(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        authController?.signIn(provider: provider, callbackId: callbackId)
        return nil
    }
    
    func signInAnonymously(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        authController?.signInAnonymously(callbackId: callbackId)
        return nil
    }
    
    func signInWithCustomToken(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let token = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        authController?.signInWithCustomToken(token: token, callbackId: callbackId)
        return nil
    }
    
    func updateProfile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2
            else {
                return FreArgError().getError()
        }
        let displayName = String(argv[0])
        let photoUrl = String(argv[1])
        let callbackId = String(argv[2])
        userController?.updateProfile(displayName: displayName, photoUrl: photoUrl, callbackId: callbackId)
        return nil
    }
    
    func signOut(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        authController?.signOut()
        return nil
    }
    
    func sendEmailVerification(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let callbackId = String(argv[0])
        userController?.sendEmailVerification(callbackId: callbackId)
        return nil
    }
    
    func updateEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let email = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        userController?.update(email: email, callbackId: callbackId)
        return nil
    }
    
    func updatePassword(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let password = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        userController?.update(password: password, callbackId: callbackId)
        return nil
    }
    
    func sendPasswordResetEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let email = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        authController?.sendPasswordReset(email: email, callbackId: callbackId)
        return nil
    }
    
    func reauthenticate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let email = String(argv[0]),
            let password = String(argv[1])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[2])
        authController?.reauthenticate(email: email, password: password, callbackId: callbackId)
        return nil
    }
    
    func unlink(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let provider = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        userController?.unlink(provider: provider, callbackId: callbackId)
        return nil
    }
    
    func link(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let credential: AuthCredential = AuthCredential.fromFREObject(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        userController?.link(credential: credential, callbackId: callbackId)
        return nil
    }
    
    func deleteUser(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        userController?.deleteUser(callbackId: callbackId)
        return nil
    }
    
    func setLanguageCode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let code = String(argv[0])
            else {
                return FreArgError().getError()
        }
        authController?.setLanguage(code: code)
        return nil
    }
    
    func getLanguageCode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return authController?.getLanguage()?.toFREObject()
    }
    
    func getCurrentUser(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return userController?.getCurrentUser()?.toFREObject()
    }
    
    func getIdToken(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let forceRefresh = Bool(argv[0]),
            let callbackId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        userController?.getIdToken(forceRefresh: forceRefresh, callbackId: callbackId)
        return nil
    }
    
    func reload(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        userController?.reload(callbackId: callbackId)
        return nil
    }
    
    func verifyPhoneNumber(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let phoneNumber = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        authController?.verifyPhoneNumber(phoneNumber: phoneNumber, callbackId: callbackId)
        return nil
    }
    
}
