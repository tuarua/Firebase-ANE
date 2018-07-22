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
import FirebaseInvites

public class SwiftController: NSObject {
    public var TAG: String? = "SwiftController"
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
    
    func openInvite(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let rv = argv[0],
            let title = String(rv["title"]),
            let message = String(rv["message"])
            else {
                return FreArgError(message: "openInvite").getError(#file, #line, #column)
        }
        
        if let invite = Invites.inviteDialog() {
            invite.setInviteDelegate(self)
            invite.setTitle(title)
            invite.setMessage(message)
            if let deepLink = String(rv["deepLink"]) {
                invite.setDeepLink(deepLink)
            }
            if let customImage = String(rv["customImage"]) {
                invite.setCustomImage(customImage)
            }
            if let callToActionText = String(rv["callToActionText"]) {
                invite.setCallToActionText(callToActionText)
            }
            
            if let otherPlatformClientId = String(rv["otherPlatformClientId"]) {
                let targetApplication = InvitesTargetApplication.init()
                targetApplication.androidClientID = otherPlatformClientId
                invite.setOtherPlatformsTargetApplication(targetApplication)
                if let androidMinimumVersionCode = Int(rv["androidMinimumVersionCode"]) {
                    invite.setAndroidMinimumVersionCode(androidMinimumVersionCode)
                }
            }
            invite.open()
        }
        return nil
    }
    
    func getDynamicLink(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError(message: "getDynamicLink").getError(#file, #line, #column)
        }
        if let userInfo = appDidFinishLaunchingNotif?.userInfo,
            let userActivityDict = userInfo[UIApplicationLaunchOptionsKey.userActivityDictionary] as? NSDictionary,
            let userActivity = userActivityDict["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity,
            let webpageURL = userActivity.webpageURL {
            Invites.handleUniversalLink(webpageURL) { (invite, error) in
                if let err = error {
                    self.dispatchEvent(name: InvitesEvent.ON_LINK,
                                   value: InvitesEvent(eventId: eventId,
                                                           error: ["text": err.localizedDescription, "id": 0]
                                    ).toJSONString())
                    return
                }
                var sourceApplication = ""
                if let source = userInfo[UIApplicationLaunchOptionsKey.sourceApplication] as? String {
                    sourceApplication = source
                }
                var sourceUrl = ""
                if let url = (userInfo[UIApplicationLaunchOptionsKey.url] as? NSURL)?.absoluteString {
                    sourceUrl = url
                }
                
                self.dispatchEvent(name: InvitesEvent.ON_LINK,
                               value: InvitesEvent(eventId: eventId,
                                                   data: ["url": invite?.deepLink ?? "",
                                                          "invitationId": invite?.inviteId ?? "",
                                                          "sourceApplication": sourceApplication,
                                                          "sourceUrl": sourceUrl]
                                ).toJSONString())
            } 
        } else {
            self.dispatchEvent(name: InvitesEvent.ON_LINK,
                           value: InvitesEvent(eventId: eventId,
                                               data: ["url": "", "invitationId": ""]
                            ).toJSONString())
        }
        
        return nil
    }
    
    @objc func applicationDidFinishLaunching(_ notification: Notification) {
        appDidFinishLaunchingNotif = notification
    }
    
}
