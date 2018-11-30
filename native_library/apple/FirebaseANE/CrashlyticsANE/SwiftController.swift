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
import Crashlytics
import Fabric

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]

    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    var crashlytics: Crashlytics {
        return Crashlytics.sharedInstance()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError(message: "initController").getError(#file, #line, #column)
        }
        let debug = Bool(argv[0]) == true
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = debug
        return true.toFREObject()
    }
    
    // MARK: - Log
    
    func crash(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        crashlytics.crash()
        return nil
    }
    
    func log(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("log is not available on iOS")
        return nil
    }
    
    func logException(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let message = String(argv[0])
            else {
                return FreArgError(message: "logException").getError(#file, #line, #column)
        }
        crashlytics.recordCustomExceptionName("CrashlyticsANE", reason: message, frameArray: [])
        return nil
    }
    
    // MARK: - Sets
    
    func setUserIdentifier(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = String(argv[0])
            else {
                return FreArgError(message: "setUserIdentifier").getError(#file, #line, #column)
        }
        crashlytics.setUserIdentifier(value)
        return nil
    }
    
    func setUserEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = String(argv[0])
            else {
                return FreArgError(message: "setUserEmail").getError(#file, #line, #column)
        }
        crashlytics.setUserEmail(value)
        return nil
    }
    
    func setUserName(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = String(argv[0])
            else {
                return FreArgError(message: "setUserName").getError(#file, #line, #column)
        }
        crashlytics.setUserName(value)
        return nil
    }
    
    func setString(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let value = String(argv[1])
            else {
                return FreArgError(message: "setString").getError(#file, #line, #column)
        }
        crashlytics.setObjectValue(value, forKey: key)
        return nil
    }
    
    func setBool(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let value = Bool(argv[1])
            else {
                return FreArgError(message: "setBool").getError(#file, #line, #column)
        }
        crashlytics.setBoolValue(value, forKey: key)
        return nil
    }
    
    func setDouble(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let value = Float(argv[1])
            else {
                return FreArgError(message: "setDouble").getError(#file, #line, #column)
        }
        crashlytics.setFloatValue(value, forKey: key)
        return nil
    }
    
    func setInt(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let value = Int(argv[1])
            else {
                return FreArgError(message: "setInt").getError(#file, #line, #column)
        }
        crashlytics.setIntValue(Int32(value), forKey: key)
        return nil
    }

}
