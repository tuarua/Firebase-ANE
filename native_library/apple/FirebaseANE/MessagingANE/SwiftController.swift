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
import FirebaseMessaging
import UserNotifications

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private var appDidFinishLaunchingNotif: Notification?
    internal var isInited = false
    internal var startToken: String?
    
    // MARK: - Init
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        isInited = true
        // read userInfo here to determine message received on start up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            if let st = self.startToken {
                self.dispatchEvent(name: MessageEvent.ON_TOKEN_REFRESHED,
                               value: MessageEvent(data: ["token": st]).toJSONString())
            }
            if let userInfo = self.appDidFinishLaunchingNotif?.userInfo,
                let message = userInfo["UIApplicationLaunchOptionsRemoteNotificationKey"] as? [AnyHashable: Any] {
                self.dispatchEvent(name: MessageEvent.ON_MESSAGE_RECEIVED,
                               value: MessageEvent(data: self.parseUserInfo(userInfo: message)).toJSONString())
            }
            self.startToken = nil
        })
        
        return true.toFREObject()
    }
    
    func getToken(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return Messaging.messaging().fcmToken?.toFREObject()
    }
    
    func subscribe(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let toTopic = String(argv[0])
            else {
                return FreArgError().getError()
        }
        Messaging.messaging().subscribe(toTopic: toTopic)
        return nil
    }
    
    func unsubscribe(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let fromTopic = String(argv[0])
            else {
                return FreArgError().getError()
        }
        Messaging.messaging().unsubscribe(fromTopic: fromTopic)
        return nil
    }
    
    @objc public func applicationDidFinishLaunching(_ notification: Notification) {
        guard let application = notification.object as? UIApplication else {
            return
        }
        
        appDidFinishLaunchingNotif = notification
        
        // [START set_messaging_delegate]
        Messaging.messaging().delegate = self
        
        // [END set_messaging_delegate]
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        // [END register_for_notifications]
    }

    func parseUserInfo(userInfo: [AnyHashable: Any]) -> [String: Any] {
        var message = [String: Any]()
        message["messageId"] = userInfo["gcm.message_id"]
        if let sentTimeStr = userInfo["google.c.a.ts"] as? String,
            let sentTime = Int(sentTimeStr) {
            message["sentTime"] = sentTime * 1000
        } else {
            message["sentTime"] = 0
        }
        
        var notification = [String: Any]()
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let body = alert["body"] as? String {
                    notification["body"] = body
                }
                if let title = alert["title"] as? String {
                    notification["title"] = title
                }
                if let sound = alert["sound"] as? String {
                    notification["sound"] = sound
                }
            } else if let alert = aps["alert"] as? NSString {
                notification["body"] = alert
            }
        }
        var userInfoCleaned = userInfo
        userInfoCleaned.removeValue(forKey: "google.c.a.ts")
        userInfoCleaned.removeValue(forKey: "aps")
        userInfoCleaned.removeValue(forKey: "gcm.message_id")
        userInfoCleaned.removeValue(forKey: "google.c.a.e")
        userInfoCleaned.removeValue(forKey: "google.c.a.udt")
        userInfoCleaned.removeValue(forKey: "gcm.notification.sound2")
        userInfoCleaned.removeValue(forKey: "gcm.n.e")
        userInfoCleaned.removeValue(forKey: "google.c.a.c_id")
        var data = [String: String]()
        for (k, v) in userInfoCleaned {
            if let key = k as? String, let val = v as? String {
                data[key] = val
            }
        }
        
        message["notification"] = notification
        message["data"] = data
        
        /*
         public var clickAction:String;
         public var color:String;
         public var icon:String;
         public var link:String;
         public var tag:String;
         */
        
        return message
    }
    
}
