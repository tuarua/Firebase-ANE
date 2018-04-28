import Foundation
import FreSwift
import Firebase

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        trace("Firebase app Name", FirebaseApp.app()?.name ?? "unknown")
        return true.toFREObject()
    }
    
    func setUserProperty(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let name = String(argv[0]),
            let value = String(argv[1])
            else {
                return ArgCountError(message: "setUserProperty").getError(#file, #line, #column)
        }
        Analytics.setUserProperty(value, forName: name)
        return nil
    }
    
    func setUserId(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return ArgCountError(message: "setUserId").getError(#file, #line, #column)
        }
        Analytics.setUserID(id)
        return nil
    }
    
    func setSessionTimeoutDuration(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let milliseconds = Int(argv[0])
            else {
                return ArgCountError(message: "setSessionTimeoutDuration").getError(#file, #line, #column)
        }
        AnalyticsConfiguration.shared().setSessionTimeoutInterval(TimeInterval(milliseconds))
        return nil
    }
    
    func setMinimumSessionDuration(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let milliseconds = Int(argv[0])
            else {
                return ArgCountError(message: "setMinimumSessionDuration").getError(#file, #line, #column)
        }
        AnalyticsConfiguration.shared().setMinimumSessionInterval(TimeInterval(milliseconds))
        return nil
    }
    
    func setCurrentScreen(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let screenName = String(argv[0])
            else {
                return ArgCountError(message: "setCurrentScreen").getError(#file, #line, #column)
        }
        Analytics.setScreenName(screenName, screenClass: nil)
        return nil
    }
    
    func logEvent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let name = String(argv[0]),
            let params = [String: NSObject](argv[1])
            else {
                return ArgCountError(message: "logEvent").getError(#file, #line, #column)
        }
        Analytics.logEvent(name, parameters: params)
        return nil
    }
    
    func resetAnalyticsData(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    func setAnalyticsCollectionEnabled(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let enabled = Bool(argv[0])
            else {
                return ArgCountError(message: "setAnalyticsCollectionEnabled").getError(#file, #line, #column)
        }
        AnalyticsConfiguration.shared().setAnalyticsCollectionEnabled(enabled)
        return nil
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
    }
    
}
