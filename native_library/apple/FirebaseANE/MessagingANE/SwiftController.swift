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
    public var TAG: String? = "SwiftController"
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
        Messaging.messaging().shouldEstablishDirectChannel = true
        isInited = true
        startToken = nil
        return true.toFREObject()
    }
    
    func getToken(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return Messaging.messaging().fcmToken?.toFREObject()
    }
    
    func subscribe(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let toTopic = String(argv[1])
            else {
                return ArgCountError(message: "subscribe").getError(#file, #line, #column)
        }
        Messaging.messaging().subscribe(toTopic: toTopic)
        return nil
    }
    
    func unsubscribe(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let fromTopic = String(argv[1])
            else {
                return ArgCountError(message: "unsubscribe").getError(#file, #line, #column)
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
        Messaging.messaging().shouldEstablishDirectChannel = true
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

}
