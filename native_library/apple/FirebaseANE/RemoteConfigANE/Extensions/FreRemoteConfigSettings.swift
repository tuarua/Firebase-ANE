import Foundation
import FreSwift
import FirebaseRemoteConfig

public extension RemoteConfigSettings {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let developerModeEnabled = Bool(rv["developerModeEnabled"])
            else { return nil }
        self.init(developerModeEnabled: developerModeEnabled)
    }
    
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.remoteconfig.RemoteConfigSettings",
                                    args: self.isDeveloperModeEnabled)
            return ret
        } catch {
        }
        return nil
    }
}
