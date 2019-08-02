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
import FirebaseDynamicLinks

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var appDidFinishLaunchingNotif: Notification?
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func buildDynamicLink(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 4,
            let linkFre = argv[0],
            let eventId = String(argv[1]),
            let copyToClipboard = Bool(argv[2]),
            let shorten = Bool(argv[3]),
            let suffix = Int(argv[4]),
            let link = String(linkFre["link"]),
            let linkUrl = URL(string: link),
            let domainUriPrefix = String(linkFre["domainUriPrefix"])
            else {
                return FreArgError(message: "buildDynamicLink").getError()
        }
        
        guard let components = DynamicLinkComponents(link: linkUrl, domainURIPrefix: domainUriPrefix) else {
            return nil }
        
        components.iOSParameters = DynamicLinkIOSParameters(linkFre["iosParameters"])
        components.iTunesConnectParameters = DynamicLinkItunesConnectAnalyticsParameters(
            linkFre["itunesConnectAnalyticsParameters"]
        )
        components.analyticsParameters = DynamicLinkGoogleAnalyticsParameters(linkFre["googleAnalyticsParameters"])
        components.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters(linkFre["socialMetaTagParameters"])
        components.androidParameters = DynamicLinkAndroidParameters(linkFre["androidParameters"])
        components.navigationInfoParameters = DynamicLinkNavigationInfoParameters(linkFre["navigationInfoParameters"])
        
        if let androidFallbackUrl =  components.androidParameters?.fallbackURL {
            let otherPlatformParams = DynamicLinkOtherPlatformParameters()
            otherPlatformParams.fallbackUrl = androidFallbackUrl
            components.otherPlatformParameters = otherPlatformParams
        }

        if shorten {
            let options = DynamicLinkComponentsOptions()
            options.pathLength = ShortDynamicLinkPathLength(rawValue: suffix) ?? .default
            components.options = options
            components.shorten { (shortURL, warnings, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: DynamicLinkEvent.ON_CREATED,
                                   value: DynamicLinkEvent(eventId: eventId,
                                                       data: nil,
                                                       error: err).toJSONString())
                    return
                }
                if copyToClipboard {
                    UIPasteboard.general.string = shortURL?.absoluteString
                }
                self.dispatchEvent(name: DynamicLinkEvent.ON_CREATED,
                               value: DynamicLinkEvent(eventId: eventId,
                                                       data: ["shortLink": shortURL?.absoluteString ?? "",
                                                              "warnings": warnings ?? []]
                                ).toJSONString())  
            }
        } else {
            if let dynamicLink = components.url?.absoluteString {
                if copyToClipboard {
                    UIPasteboard.general.string = dynamicLink
                }
                self.dispatchEvent(name: DynamicLinkEvent.ON_CREATED,
                               value: DynamicLinkEvent(eventId: eventId,
                                                       data: ["url": dynamicLink]).toJSONString())
            }
        }
        
        return nil
    }

    func getDynamicLink(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError(message: "getDynamicLink").getError()
        }
        if let userInfo = appDidFinishLaunchingNotif?.userInfo,
            let userActivityDict = userInfo[UIApplication.LaunchOptionsKey.userActivityDictionary] as? NSDictionary,
            let userActivity = userActivityDict["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
            let webpageURL = userActivity.webpageURL {
    
            DynamicLinks.dynamicLinks().handleUniversalLink(webpageURL, completion: { (link, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: DynamicLinkEvent.ON_LINK,
                                   value: DynamicLinkEvent(eventId: eventId,
                                                           error: err
                                    ).toJSONString())
                    return
                }
                self.dispatchEvent(name: DynamicLinkEvent.ON_LINK,
                               value: DynamicLinkEvent(eventId: eventId,
                                                       data: ["url": link?.url?.absoluteString ?? ""]
                                ).toJSONString())
            })
        } else {
            self.dispatchEvent(name: DynamicLinkEvent.ON_LINK,
                           value: DynamicLinkEvent(eventId: eventId,
                                                   data: ["url": ""]
                            ).toJSONString())
        }
        
        return nil
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        appDidFinishLaunchingNotif = notification
    }

}
