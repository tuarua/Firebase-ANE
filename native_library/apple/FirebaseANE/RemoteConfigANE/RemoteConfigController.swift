import FreSwift
import FirebaseRemoteConfig

class RemoteConfigController: FreSwiftController {
    var TAG: String? = "RemoteConfigController"
    internal var context: FreContextSwift!
    private var remoteConfig: RemoteConfig!
    private var cacheExpiration: Int = 86400
    
    convenience init(context: FreContextSwift) {
        self.init()
        self.context = context
        remoteConfig = RemoteConfig.remoteConfig()
    }
    
    public func setConfigSettings(settings: RemoteConfigSettings) {
        remoteConfig.configSettings = settings
    }
    public func fetch(cacheExpiration: Int) {
        self.cacheExpiration = remoteConfig.configSettings.isDeveloperModeEnabled ? 0 : cacheExpiration
        
        trace("fetching with expiration of \(self.cacheExpiration)")
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(self.cacheExpiration)) { (status, error) -> Void in
            if status == .success {
                self.remoteConfig.activateFetched()
                self.sendEvent(name: RemoteConfigEvent.FETCH, value: "")
            } else {
                self.sendEvent(name: RemoteConfigErrorEvent.FETCH_ERROR,
                               value: RemoteConfigErrorEvent.init(
                                eventId: "",
                                text: error?.localizedDescription,
                                id: 0
                                ).toJSONString())
            }
        }
    }
    
    func setDefaults(value: [String: NSObject]) {
        remoteConfig.setDefaults(value)
    }
    
    func getByteArray(key: String) -> Data? {
        return remoteConfig[key].dataValue
    }
    
    func getBoolean(key: String) -> Bool {
        return remoteConfig[key].boolValue
    }
    
    func getDouble(key: String) -> Double {
        return Double(truncating: remoteConfig[key].numberValue ?? 0)
    }
    
    func getLong(key: String) -> Int {
        return Int(truncating: remoteConfig[key].numberValue ?? 0)
    }
    
    func getKeysByPrefix(key: String) -> [String] {
        return [String](remoteConfig.keys(withPrefix: key))
    }
    
    public func getString(key: String) -> String? {
        return remoteConfig[key].stringValue
    }
    
    public func getInfo() -> RemoteConfig {
        return remoteConfig
    }
    
    public func activateFetched() {
        remoteConfig.activateFetched()
    }
    
}
