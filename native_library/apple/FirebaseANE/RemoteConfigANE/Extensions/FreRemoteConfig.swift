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
