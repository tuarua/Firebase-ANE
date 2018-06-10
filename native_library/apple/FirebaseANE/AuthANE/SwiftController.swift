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
    public var TAG: String? = "SwiftController"
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
                return ArgCountError(message: "createUserWithEmailAndPassword").getError(#file, #line, #column)
        }
        let eventId = String(argv[2])
        authController?.createUser(email: email, password: password, eventId: eventId)
        return nil
        
    }
    
    func signIn(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let credential: AuthCredential = AuthCredential.fromFREObject(argv[0])
            else {
                return ArgCountError(message: "signIn").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        authController?.signIn(credential: credential, eventId: eventId)
        return nil
    }
    
    func signInAnonymously(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return ArgCountError(message: "signInAnonymously").getError(#file, #line, #column)
        }
        let eventId = String(argv[0])
        authController?.signInAnonymously(eventId: eventId)
        return nil
    }
    
    func signInWithCustomToken(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let token = String(argv[0])
            else {
                return ArgCountError(message: "signInWithCustomToken").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        authController?.signInWithCustomToken(token: token, eventId: eventId)
        return nil
    }
    
    func updateProfile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2
            else {
                return ArgCountError(message: "signInWithEmailAndPassword").getError(#file, #line, #column)
        }
        let displayName = String(argv[0])
        let photoUrl = String(argv[1])
        let eventId = String(argv[2])
        userController?.updateProfile(displayName: displayName, photoUrl: photoUrl, eventId: eventId)
        return nil
    }
    
    func signOut(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        authController?.signOut()
        return nil
    }
    
    func sendEmailVerification(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        let eventId = String(argv[0])
        userController?.sendEmailVerification(eventId: eventId)
        return nil
    }
    
    func updateEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let email = String(argv[0])
            else {
                return ArgCountError(message: "updateEmail").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        userController?.update(email: email, eventId: eventId)
        return nil
    }
    
    func updatePassword(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let password = String(argv[0])
            else {
                return ArgCountError(message: "updatePassword").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        userController?.update(password: password, eventId: eventId)
        return nil
    }
    
    func sendPasswordResetEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let email = String(argv[0])
            else {
                return ArgCountError(message: "sendPasswordResetEmail").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        authController?.sendPasswordReset(email: email, eventId: eventId)
        return nil
    }
    
    func reauthenticate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let email = String(argv[0]),
            let password = String(argv[1])
            else {
                return ArgCountError(message: "reauthenticate").getError(#file, #line, #column)
        }
        let eventId = String(argv[2])
        authController?.reauthenticate(email: email, password: password, eventId: eventId)
        return nil
    }
    
    func unlink(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let provider = String(argv[0])
            else {
                return ArgCountError(message: "unlink").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        userController?.unlink(provider: provider, eventId: eventId)
        return nil
    }
    
    func link(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let credential: AuthCredential = AuthCredential.fromFREObject(argv[0])
            else {
                return ArgCountError(message: "link").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        userController?.link(credential: credential, eventId: eventId)
        return nil
    }
    
    func deleteUser(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return ArgCountError(message: "remove").getError(#file, #line, #column)
        }
        let eventId = String(argv[0])
        userController?.deleteUser(eventId: eventId)
        return nil
    }
    
    func setLanguageCode(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let code = String(argv[0])
            else {
                return ArgCountError(message: "setLanguageCode").getError(#file, #line, #column)
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
            let eventId = String(argv[1])
            else {
                return ArgCountError(message: "getIdToken").getError(#file, #line, #column)
        }
        userController?.getIdToken(forceRefresh: forceRefresh, eventId: eventId)
        return nil
    }
    
    func reload(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return ArgCountError(message: "reload").getError(#file, #line, #column)
        }
        let eventId = String(argv[0])
        userController?.reload(eventId: eventId)
        return nil
    }
    
    func verifyPhoneNumber(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let phoneNumber = String(argv[0])
            else {
                return ArgCountError(message: "verifyPhoneNumber").getError(#file, #line, #column)
        }
        let eventId = String(argv[1])
        authController?.verifyPhoneNumber(phoneNumber: phoneNumber, eventId: eventId)
        return nil
    }
    
}
