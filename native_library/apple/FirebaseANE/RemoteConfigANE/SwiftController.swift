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
import FirebaseRemoteConfig

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var remoteConfig: RemoteConfig?
    private var cacheExpiration: Int = 86400
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        remoteConfig = RemoteConfig.remoteConfig()
        return true.toFREObject()
    }
    
    func setDefaults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let defaults = [String: NSObject](argv[0])
            else {
                return FreArgError(message: "setDefaults").getError(#file, #line, #column)
        }
        remoteConfig?.setDefaults(defaults)
        return nil
    }
    
    func setConfigSettings(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
        let settings = RemoteConfigSettings(argv[0])
            else {
                return FreArgError(message: "setConfigSettings").getError(#file, #line, #column)
        }
        remoteConfig?.configSettings = settings
        return nil
    }
    
    func getByteArray(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return FreArgError(message: "getByteArray").getError(#file, #line, #column)
        }
        if let rc = remoteConfig {
            let data = rc[key].dataValue
            let freBa = FreByteArraySwift(data: data as NSData)
            return freBa.rawValue
        }
        
        return nil
    }
    
    func getBoolean(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError(message: "getBoolean").getError(#file, #line, #column)
        }
        return rc[key].boolValue.toFREObject()
    }
    
    func getDouble(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError(message: "getDouble").getError(#file, #line, #column)
        }
        return Double(truncating: rc[key].numberValue ?? 0).toFREObject()
    }
    
    func getLong(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError(message: "getLong").getError(#file, #line, #column)
        }
        return Int(truncating: rc[key].numberValue ?? 0).toFREObject()
    }
    
    func getString(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError(message: "getString").getError(#file, #line, #column)
        }
        return rc[key].stringValue?.toFREObject()
    }
    
    func getKeysByPrefix(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError(message: "getKeysByPrefix").getError(#file, #line, #column)
        }
        return [String](rc.keys(withPrefix: key)).toFREObject()
    }
    
    func activateFetched(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return remoteConfig?.activateFetched().toFREObject()
    }
    
    func getInfo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return remoteConfig?.toFREObject()
    }
    
    func fetch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let cacheExpiration = Int(argv[0])
            else {
                return FreArgError(message: "fetch").getError(#file, #line, #column)
        }
        self.cacheExpiration = rc.configSettings.isDeveloperModeEnabled ? 0 : cacheExpiration
        
        remoteConfig?.fetch(withExpirationDuration: TimeInterval(self.cacheExpiration)) { (status, error) -> Void in
            if status == .success {
                self.remoteConfig?.activateFetched()
                self.sendEvent(name: RemoteConfigEvent.FETCH, value: "")
            } else {
                self.sendEvent(name: RemoteConfigErrorEvent.FETCH_ERROR,
                               value: RemoteConfigErrorEvent(
                                eventId: "",
                                text: error?.localizedDescription,
                                id: 0
                                ).toJSONString())
            }
        }
        
        return nil
    }
    
}
