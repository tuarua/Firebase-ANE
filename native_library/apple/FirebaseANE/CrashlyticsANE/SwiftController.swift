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
import FirebaseCrashlytics

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]

    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    var crashlytics: Crashlytics {
        return Crashlytics.crashlytics()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        crashlytics.setCrashlyticsCollectionEnabled(Bool(argv[0]) == true)
        return true.toFREObject()
    }
    
    // MARK: - Log
    
    func crash(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        fatalError()
    }
    
    func log(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        warning("log is not available on iOS")
        return nil
    }
    
    func recordException(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let reason = String(argv[0])
            else {
                return FreArgError().getError()
        }
        crashlytics.record(exceptionModel: .init(name: "CrashlyticsANE", reason: reason))
        return nil
    }
    
    // MARK: - Sets
    
    func setUserId(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = String(argv[0])
            else {
                return FreArgError().getError()
        }
        crashlytics.setUserID(value)
        return nil
    }
    
    func setCustomKey(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let value = argv[1]
            else {
                return FreArgError().getError()
        }
        
        switch value.type {
        case .string:
            crashlytics.setCustomValue(String(value) as Any, forKey: key)
        case .int:
            crashlytics.setCustomValue(Int(value) as Any, forKey: key)
        case .number:
            crashlytics.setCustomValue(Double(value) as Any, forKey: key)
        case .boolean:
            crashlytics.setCustomValue(Bool(value) as Any, forKey: key)
        default: break
        }
        return nil
    }

    func didCrashOnPreviousExecution(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return crashlytics.didCrashDuringPreviousExecution().toFREObject()
    }
    
}
