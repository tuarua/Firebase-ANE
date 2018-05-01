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

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    private var authController: AuthController?
    private var userController: UserController?
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        authController = AuthController(context: context)
        userController = UserController(context: context)
        return true.toFREObject()
    }
    
    func createUserWithEmailAndPassword(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let email = String(argv[0]),
            let password = String(argv[1])
            else {
                return ArgCountError(message: "createUserWithEmailAndPassword").getError(#file, #line, #column)
        }
        authController?.createUser(email: email, password: password)
        return nil
        
    }
    
    func signInWithEmailAndPassword(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        
        trace("signInWithEmailAndPassword")
        
        guard argc > 1,
            let email = String(argv[0]),
            let password = String(argv[1])
            else {
                return ArgCountError(message: "signInWithEmailAndPassword").getError(#file, #line, #column)
        }
        authController?.signIn(email: email, password: password)
        return nil
    }
    
    func signInAnonymously(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("signInAnonymously")
        authController?.signInAnonymously()
        return nil
    }
    
    func updateProfile(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    func signOut(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        authController?.signOut()
        return nil
    }
    func sendEmailVerification(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        userController?.sendEmailVerification()
        return nil
    }
    func updateEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let email = String(argv[0])
            else {
                return ArgCountError(message: "updateEmail").getError(#file, #line, #column)
        }
        userController?.update(email: email)
        return nil
    }
    func updatePassword(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let password = String(argv[0])
            else {
                return ArgCountError(message: "updatePassword").getError(#file, #line, #column)
        }
        userController?.update(password: password)
        return nil
    }
    func sendPasswordResetEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let email = String(argv[0])
            else {
                return ArgCountError(message: "sendPasswordResetEmail").getError(#file, #line, #column)
        }
        authController?.sendPasswordReset(email: email)
        return nil
    }
    func deleteUser(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        authController?.deleteUser()
        return nil
    }
    func reauthenticate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let email = String(argv[0]),
            let password = String(argv[1])
            else {
                return ArgCountError(message: "reauthenticate").getError(#file, #line, #column)
        }
        authController?.reauthenticate(email: email, password: password)
        return nil
    }
    func unlink(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let provider = String(argv[0])
            else {
                return ArgCountError(message: "unlink").getError(#file, #line, #column)
        }
        userController?.unlink(provider: provider)
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
        // TODO
        return nil
    }
}
