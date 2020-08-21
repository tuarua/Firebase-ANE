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
import OneSignal

public class SwiftController: NSObject, OSInAppMessageDelegate {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    
    // MARK: - Init
    
    public func handleMessageAction(action: OSInAppMessageAction) {
        // TODO
    }
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return true.toFREObject()
    }
    
    func getVersion(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return OneSignal.sdk_version_raw()?.toFREObject()
    }
    
    func getSdkType(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    func setLogLevel(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let logLevel = ONE_S_LOG_LEVEL(rawValue: UInt(argv[0]) ?? 0),
            let visualLevel = ONE_S_LOG_LEVEL(rawValue: UInt(argv[1]) ?? 0)
            else {
                return FreArgError().getError()
        }
        OneSignal.setLogLevel(logLevel, visualLevel: visualLevel)
        return nil
    }
    
    func setInFocusDisplaying(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let type = OSNotificationDisplayType(rawValue: UInt(argv[0]) ?? 2)
            else {
                return FreArgError().getError()
        }
        OneSignal.inFocusDisplayType = type
        return nil
    }
    
    func setRequiresUserPrivacyConsent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        OneSignal.setRequiresUserPrivacyConsent(Bool(argv[0]) == true)
        return nil
    }
    
    func consentGranted(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        OneSignal.consentGranted(Bool(argv[0]) == true)
        return nil
    }
    
    func userProvidedPrivacyConsent(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return OneSignal.requiresUserPrivacyConsent().toFREObject()
    }
    
    func setLocationShared(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        OneSignal.setLocationShared(Bool(argv[0]) == true)
        return nil
    }
    
    func promptLocation(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        OneSignal.promptLocation()
        return nil
    }
    
    func sendTag(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let value = String(argv[1])
            else {
                return FreArgError().getError()
        }
        OneSignal.sendTag(key, value: value)
        return nil
    }
    
    func sendTags(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let json = String(argv[0])
            else {
                return FreArgError().getError()
        }
        OneSignal.sendTags(withJsonString: json)
        return nil
    }
    
    func getTags(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let callbackId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        OneSignal.getTags { results in
            guard let results = results else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_GET_TAGS,
                               value: OneSignalEvent(callbackId: callbackId,
                                                     data: ["results": results]).toJSONString())
        }
        return nil
    }
    
    func deleteTag(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        OneSignal.deleteTag(key)
        return nil
    }
    
    func deleteTags(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let keys = [String](argv[0])
            else {
                return FreArgError().getError()
        }
        OneSignal.deleteTags(keys)
        return nil
    }
    
    func setEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let email = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let emailAuthHash = String(argv[1])
        let callbackSuccessId = String(argv[2])
        let callbackFailureId = String(argv[3])
        
        OneSignal.setEmail(email, withEmailAuthHashToken: emailAuthHash, withSuccess: {
            guard let callbackSuccessId = callbackSuccessId else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_SET_EMAIL_SUCCESS,
                               value: OneSignalEvent(callbackId: callbackSuccessId).toJSONString())
        }, withFailure: { error in
            guard let callbackFailureId = callbackFailureId, let err = error as NSError? else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_SET_EMAIL_SUCCESS,
                               value: OneSignalEvent(callbackId: callbackFailureId, error: err).toJSONString())
        })
        
        return nil
    }
    
    func logoutEmail(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        OneSignal.logoutEmail()
        return nil
    }
    
    func addTrigger(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let key = String(argv[0]),
            let fre1 = argv[0]
            else {
                return FreArgError().getError()
        }
        
        var value: Any?
        switch fre1.type {
        case .int:
            value = Int(fre1)
        case .string:
            value = String(fre1)
        default:
            return nil
        }
        
        if let value = value {
            OneSignal.addTrigger(key, withValue: value)
        }
        
        return nil
    }
    
    func addTriggers(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let jsonStr = String(argv[0]),
            let json = JSON(jsonStr).dictionaryObject
            else {
                return FreArgError().getError()
        }
        OneSignal.addTriggers(json)
        return nil
    }
    
    func removeTriggerForKey(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        OneSignal.removeTrigger(forKey: key)
        return nil
    }
    
    func removeTriggersForKeys(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let keys = [String](argv[0])
            else {
                return FreArgError().getError()
        }
        OneSignal.removeTriggers(forKeys: keys)
        return nil
    }
    
    func getTriggerValueForKey(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let key = String(argv[0])
            else {
                return FreArgError().getError()
        }
        if let object = OneSignal.getTriggerValue(forKey: key) {
            return JSON(object).description.toFREObject()
        }
        return nil
    }
    
    func pauseInAppMessages(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        OneSignal.pause(inAppMessages: Bool(argv[0]) == true)
        return nil
    }
    
    func getPermissionSubscriptionState(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return OneSignal.getPermissionSubscriptionState().toFREObject()
    }
    
    func setSubscription(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        OneSignal.setSubscription(Bool(argv[0]) == true)
        return nil
    }
    
    func setExternalUserId(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let userId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[1])
        OneSignal.setExternalUserId(userId) { results in
            guard let callbackId = callbackId, let results = results else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_SET_EXTERNAL_USERID,
                               value: OneSignalEvent(callbackId: callbackId,
                                  data: ["results": results]).toJSONString())
        }
        return nil
    }
    
    func removeExternalUserId(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0
            else {
                return FreArgError().getError()
        }
        let callbackId = String(argv[0])
        OneSignal.removeExternalUserId { results in
            guard let callbackId = callbackId, let results = results else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_REMOVE_EXTERNAL_USERID,
                               value: OneSignalEvent(callbackId: callbackId,
                                                     data: ["results": results]).toJSONString())
        }
        return nil
    }
    
    func postNotification(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let json = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let callbackSuccessId = String(argv[1])
        let callbackFailureId = String(argv[2])
        
        OneSignal.postNotification(withJsonString: json, onSuccess: { response in
            guard let callbackSuccessId = callbackSuccessId,
                let response = response else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_POST_NOTIFICATION_SUCCESS,
                               value: OneSignalEvent(callbackId: callbackSuccessId,
                                                     data: ["response": response]).toJSONString())
        }, onFailure: { error in
            guard let callbackFailureId = callbackFailureId,
                let err = error as NSError? else { return }
            self.dispatchEvent(name: OneSignalEvent.ON_POST_NOTIFICATION_FAILURE,
            value: OneSignalEvent(callbackId: callbackFailureId,
                                  error: err).toJSONString())
        })
        
        return nil
    }
    
    func cancelNotification(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    func clearOneSignalNotifications(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    func enableVibrate(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
    func enableSound(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
}
