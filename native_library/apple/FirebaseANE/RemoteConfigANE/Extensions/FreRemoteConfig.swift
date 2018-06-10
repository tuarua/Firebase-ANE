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

public extension RemoteConfig {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.remoteconfig.RemoteConfigInfo")
            try ret?.setProp(name: "fetchTime", value: self.lastFetchTime?.timeIntervalSince1970)
            try ret?.setProp(name: "lastFetchStatus", value: self.lastFetchStatus.rawValue)
            try ret?.setProp(name: "configSettings", value: self.configSettings.toFREObject())
            return ret
        } catch {
        }
        return nil
    }
}
