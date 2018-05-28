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
    
    func isGooglePlayServicesAvailable(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        appDidFinishLaunchingNotif = notification
        if Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") != nil {
            hasGooglePlist = true
            // check Info.plist for CFBundleURLSchemes
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                if let bundleURLTypes = dict["CFBundleURLTypes"] as? NSArray {
                    if let bundleURLSchemesDict = bundleURLTypes[0] as? NSDictionary {
                        if let bundleURLSchemes = bundleURLSchemesDict["CFBundleURLSchemes"] as? NSArray,
                            let v = bundleURLSchemes.firstObject as? String {
                            FirebaseOptions.defaultOptions()?.deepLinkURLScheme = v
                        }
                    }
                }
            }
            FirebaseApp.configure()
            
        } else {
            hasGooglePlist = false
        }
    }
    
}
