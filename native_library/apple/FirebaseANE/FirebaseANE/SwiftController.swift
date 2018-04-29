import Foundation
import FreSwift
import Firebase

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var appDidFinishLaunchingNotif: Notification?
    private var hasGooglePlist: Bool = false
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard hasGooglePlist else {
            let msg = "Cannot find required GoogleService-Info.plist. Ensure Firebase config file added to AIR project"
            return FreError(stackTrace: "",
                            message: msg,
                            type: .illegalState).getError(#file, #line, #column)
        }
        guard FirebaseApp.app() != nil else {
            return FreError(stackTrace: "",
                            message: "Cannot read options. FirebaseApp not configured.",
                            type: .illegalState).getError(#file, #line, #column)
            
        }
        return true.toFREObject()
    }
    
    func getOptions(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard let app = FirebaseApp.app() else {
                return FreError(stackTrace: "",
                                message: "Cannot read options. FirebaseApp not configured.",
                                type: .illegalState).getError(#file, #line, #column)       
        }
        return app.options.toFREObject()
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        appDidFinishLaunchingNotif = notification
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            hasGooglePlist = true
            FirebaseApp.configure()
        } else {
            hasGooglePlist = false
        }
    }
    
}
