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
        trace("Firebase app Name", FirebaseApp.app()?.name ?? "unknown")
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
        let options = app.options
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.FirebaseOptions")
            try ret?.setProp(name: "bundleId", value: options.bundleID)
            try ret?.setProp(name: "androidClientId", value: options.androidClientID)
            try ret?.setProp(name: "trackingId", value: options.trackingID)
            try ret?.setProp(name: "apiKey", value: options.apiKey)
            try ret?.setProp(name: "googleAppId", value: options.googleAppID)
            try ret?.setProp(name: "databaseUrl", value: options.databaseURL)
            try ret?.setProp(name: "storageBucket", value: options.storageBucket)
            try ret?.setProp(name: "clientId", value: options.clientID)
            try ret?.setProp(name: "projectId", value: options.projectID)
            try ret?.setProp(name: "gcmSenderId", value: options.gcmSenderID)
            try ret?.setProp(name: "deepLinkUrlScheme", value: options.deepLinkURLScheme)
            return ret
        } catch let e as FreError {
            return e.getError(#file, #line, #column)
        } catch {
        }
        return nil
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
