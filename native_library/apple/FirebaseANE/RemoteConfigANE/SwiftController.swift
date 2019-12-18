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
    public static var TAG = "SwiftController"
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
                return FreArgError().getError()
        }
        remoteConfig?.setDefaults(defaults)
        return nil
    }
    
    func setConfigSettings(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
        let settings = RemoteConfigSettings(argv[0])
            else {
                return FreArgError().getError()
        }
        remoteConfig?.configSettings = settings
        return nil
    }
    
    func getByteArray(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
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
                return FreArgError().getError()
        }
        return rc[key].boolValue.toFREObject()
    }
    
    func getDouble(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return Double(truncating: rc[key].numberValue ?? 0).toFREObject()
    }
    
    func getLong(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return Int(truncating: rc[key].numberValue ?? 0).toFREObject()
    }
    
    func getString(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return rc[key].stringValue?.toFREObject()
    }
    
    func getKeysByPrefix(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return [String](rc.keys(withPrefix: key)).toFREObject()
    }
    
    func activateFetched(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return remoteConfig?.activateFetched().toFREObject()
    }
    
    func activate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        remoteConfig?.activate(completionHandler: { (error) in
            if let err = error {
                self.dispatchEvent(name: RemoteConfigErrorEvent.ACTIVATE_ERROR,
                value: RemoteConfigErrorEvent(
                 eventId: "",
                 text: err.localizedDescription,
                 id: 0
                 ).toJSONString())
            } else {
                self.dispatchEvent(name: RemoteConfigEvent.FETCH, value: "")
            }
        })
        return nil
    }
    
    func fetchAndActivate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        remoteConfig?.fetchAndActivate(completionHandler: { (status, error) in
            switch status {
            case .successFetchedFromRemote, .successUsingPreFetchedData:
                self.dispatchEvent(name: RemoteConfigEvent.FETCH, value: "")
            case .error:
                self.dispatchEvent(name: RemoteConfigErrorEvent.FETCH_ERROR,
                value: RemoteConfigErrorEvent(
                 eventId: "",
                 text: error?.localizedDescription,
                 id: 0
                 ).toJSONString())
            @unknown default: break
            }
        })
        return nil
    }
    
    func getInfo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return remoteConfig?.toFREObject()
    }
    
    func fetch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rc = remoteConfig,
            let cacheExpiration = Int(argv[0])
            else {
                return FreArgError().getError()
        }
        self.cacheExpiration = rc.configSettings.isDeveloperModeEnabled ? 0 : cacheExpiration
        
        remoteConfig?.fetch(withExpirationDuration: TimeInterval(self.cacheExpiration)) { (status, error) in
            if status == .success {
                self.remoteConfig?.activateFetched()
                self.dispatchEvent(name: RemoteConfigEvent.FETCH, value: "")
            } else {
                self.dispatchEvent(name: RemoteConfigErrorEvent.FETCH_ERROR,
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
