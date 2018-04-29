import Foundation
import FreSwift
import FirebaseRemoteConfig

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var remoteConfigController: RemoteConfigController?
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        remoteConfigController = RemoteConfigController(context: context)
        return true.toFREObject()
    }
    
    func setDefaults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let defaults = [String: NSObject](argv[0])
            else {
                return ArgCountError(message: "setDefaults").getError(#file, #line, #column)
        }
        remoteConfigController?.setDefaults(value: defaults)
        return nil
    }
    
    func setConfigSettings(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
        let settings = RemoteConfigSettings.init(argv[0])
            else {
                return ArgCountError(message: "setConfigSettings").getError(#file, #line, #column)
        }
        remoteConfigController?.setConfigSettings(settings: settings)
        return nil
    }
    
    func getByteArray(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return ArgCountError(message: "getByteArray").getError(#file, #line, #column)
        }
        if let data = remoteConfigController?.getByteArray(key: key) {
            let freBa = FreByteArraySwift(data: data as NSData)
            return freBa.rawValue
        }
        return nil
    }
    
    func getBoolean(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return ArgCountError(message: "getBoolean").getError(#file, #line, #column)
        }
        return remoteConfigController?.getBoolean(key: key).toFREObject()
    }
    
    func getDouble(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return ArgCountError(message: "getDouble").getError(#file, #line, #column)
        }
        return remoteConfigController?.getDouble(key: key).toFREObject()
    }
    
    func getLong(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return ArgCountError(message: "getLong").getError(#file, #line, #column)
        }
        return remoteConfigController?.getLong(key: key).toFREObject()
    }
    
    func getString(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return ArgCountError(message: "getString").getError(#file, #line, #column)
        }
        return remoteConfigController?.getString(key: key)?.toFREObject()
    }
    
    func getKeysByPrefix(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return ArgCountError(message: "getString").getError(#file, #line, #column)
        }
        return remoteConfigController?.getKeysByPrefix(key: key).toFREObject()
    }
    
    func activateFetched(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        remoteConfigController?.activateFetched()
        return nil
    }
    
    func getInfo(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return remoteConfigController?.getInfo().toFREObject()
    }
    
    func fetch(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let cacheExpiration = Int(argv[0])
            else {
                return ArgCountError(message: "setConfigSettings").getError(#file, #line, #column)
        }
        remoteConfigController?.fetch(cacheExpiration: cacheExpiration)
        return nil
    }
    
}
