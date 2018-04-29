import Foundation
import FreSwift

extension SwiftController: FreSwiftMainController {
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)getAppInstanceId"] = getAppInstanceId
        functionsToSet["\(prefix)setUserProperty"] = setUserProperty
        functionsToSet["\(prefix)setUserId"] = setUserId
        functionsToSet["\(prefix)setSessionTimeoutDuration"] = setSessionTimeoutDuration
        functionsToSet["\(prefix)setMinimumSessionDuration"] = setMinimumSessionDuration
        functionsToSet["\(prefix)setCurrentScreen"] = setCurrentScreen
        functionsToSet["\(prefix)setAnalyticsCollectionEnabled"] = setAnalyticsCollectionEnabled
        functionsToSet["\(prefix)logEvent"] = logEvent
        functionsToSet["\(prefix)resetAnalyticsData"] = resetAnalyticsData

        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        
        return arr
    }
    
    @objc public func dispose() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Must have this function. It exposes the methods to our entry ObjC.
    @objc public func callSwiftFunction(name: String, ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        if let fm = functionsToSet[name] {
            return fm(ctx, argc, argv)
        }
        return nil
    }
    
    @objc public func setFREContext(ctx: FREContext) {
        self.context = FreContextSwift.init(freContext: ctx)
    }
    
    @objc public func onLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidFinishLaunching),
                                               name: NSNotification.Name.UIApplicationDidFinishLaunching, object: nil)
    }
}
