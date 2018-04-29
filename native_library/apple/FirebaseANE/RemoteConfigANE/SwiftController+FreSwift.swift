import Foundation
import FreSwift

extension SwiftController: FreSwiftMainController {
    @objc public func getFunctions(prefix: String) -> [String] {
        functionsToSet["\(prefix)init"] = initController
        functionsToSet["\(prefix)setDefaults"] = setDefaults
        functionsToSet["\(prefix)setConfigSettings"] = setConfigSettings
        functionsToSet["\(prefix)getByteArray"] = getByteArray
        functionsToSet["\(prefix)getBoolean"] = getBoolean
        functionsToSet["\(prefix)getDouble"] = getDouble
        functionsToSet["\(prefix)getLong"] = getLong
        functionsToSet["\(prefix)getString"] = getString
        functionsToSet["\(prefix)getKeysByPrefix"] = getKeysByPrefix
        functionsToSet["\(prefix)fetch"] = fetch
        functionsToSet["\(prefix)activateFetched"] = activateFetched
        functionsToSet["\(prefix)getInfo"] = getInfo

        var arr: [String] = []
        for key in functionsToSet.keys {
            arr.append(key)
        }
        
        return arr
    }
    
    @objc public func dispose() {
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
    }
}
