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
import GoogleSignIn

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    public var hasFirebaseApp: Bool = false
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if hasFirebaseApp, let options = argv[0] {
            if let serverClientId = String(options["serverClientId"]) {
                GIDSignIn.sharedInstance().serverClientID = serverClientId
            }
            if let scopes = [String](options["scopes"]) {
                GIDSignIn.sharedInstance().scopes = scopes
            }
        }
        return hasFirebaseApp.toFREObject()
    }
    
    func signIn(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            GIDSignIn.sharedInstance()?.presentingViewController = rootViewController
        }
        GIDSignIn.sharedInstance().signIn()
        return nil
    }
    
    func signInSilently(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() == true {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        }
        return nil
    }
    
    func signOut(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        GIDSignIn.sharedInstance().signOut()
        return nil
    }
    
    func revokeAccess(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        GIDSignIn.sharedInstance().disconnect()
        return nil
    }
    
    func handle(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let u = String(argv[0]),
            let url = URL(string: u)
            else {
                return FreArgError().getError()
        }
        GIDSignIn.sharedInstance().handle(url)
        return nil
    }

}
