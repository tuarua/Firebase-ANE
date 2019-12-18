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
import FirebasePerformance

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var traces: [String: Trace] = [:]
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let isDataCollectionEnabled = Bool(argv[0]),
            let isInstrumentationEnabled = Bool(argv[1])
            else {
                return FreArgError().getError()
        }
        Performance.sharedInstance().isDataCollectionEnabled = isDataCollectionEnabled
        Performance.sharedInstance().isInstrumentationEnabled = isInstrumentationEnabled
        return true.toFREObject()
    }
    
    func startTrace(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let name = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if traces[name] == nil {
            traces[name] = Performance.startTrace(name: name)
        }
        traces[name]?.start()
        return nil
    }
    
    func stopTrace(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let name = String(argv[0])
            else {
                return FreArgError().getError()
        }
        traces[name]?.stop()
        return nil
    }
    
    func incrementMetric(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let name = String(argv[0]),
            let counterName = String(argv[1]),
            let by = Int(argv[2])
            else {
                return FreArgError().getError()
        }
        traces[name]?.incrementMetric(counterName, by: Int64(by))
        return nil
    }
    
    func setIsDataCollectionEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = Bool(argv[0])
            else {
                return FreArgError().getError()
        }
        Performance.sharedInstance().isDataCollectionEnabled = value
        return nil
    }
    
    func setIsInstrumentationEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let value = Bool(argv[0])
            else {
                return FreArgError().getError()
        }
        Performance.sharedInstance().isInstrumentationEnabled = value
        return nil
    }
    
}
