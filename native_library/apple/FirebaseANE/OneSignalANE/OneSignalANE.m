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

#import "FreMacros.h"
#import "OneSignalANE_oc.h"

#define FRE_OBJC_BRIDGE TROSIGS_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation OneSignalANE_LIB
SWIFT_DECL(TROSIGS)
CONTEXT_INIT(TROSIGS) {
    SWIFT_INITS(TROSIGS)
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TROSIGS, init)
        ,MAP_FUNCTION(TROSIGS, createGUID)
        ,MAP_FUNCTION(TROSIGS, getVersion)
        ,MAP_FUNCTION(TROSIGS, getSdkType)
        ,MAP_FUNCTION(TROSIGS, setLogLevel)
        ,MAP_FUNCTION(TROSIGS, setInFocusDisplaying)
        ,MAP_FUNCTION(TROSIGS, setRequiresUserPrivacyConsent)
        ,MAP_FUNCTION(TROSIGS, consentGranted)
        ,MAP_FUNCTION(TROSIGS, userProvidedPrivacyConsent)
        ,MAP_FUNCTION(TROSIGS, setLocationShared)
        ,MAP_FUNCTION(TROSIGS, promptLocation)
        ,MAP_FUNCTION(TROSIGS, sendTag)
        ,MAP_FUNCTION(TROSIGS, sendTags)
        ,MAP_FUNCTION(TROSIGS, getTags)
        ,MAP_FUNCTION(TROSIGS, deleteTag)
        ,MAP_FUNCTION(TROSIGS, deleteTags)
        ,MAP_FUNCTION(TROSIGS, setEmail)
        ,MAP_FUNCTION(TROSIGS, logoutEmail)
        ,MAP_FUNCTION(TROSIGS, addTrigger)
        ,MAP_FUNCTION(TROSIGS, addTriggers)
        ,MAP_FUNCTION(TROSIGS, removeTriggerForKey)
        ,MAP_FUNCTION(TROSIGS, removeTriggersForKeys)
        ,MAP_FUNCTION(TROSIGS, getTriggerValueForKey)
        ,MAP_FUNCTION(TROSIGS, pauseInAppMessages)
        ,MAP_FUNCTION(TROSIGS, getPermissionSubscriptionState)
        ,MAP_FUNCTION(TROSIGS, setSubscription)
        ,MAP_FUNCTION(TROSIGS, setExternalUserId)
        ,MAP_FUNCTION(TROSIGS, removeExternalUserId)
        ,MAP_FUNCTION(TROSIGS, postNotification)
        ,MAP_FUNCTION(TROSIGS, cancelNotification)
        ,MAP_FUNCTION(TROSIGS, clearOneSignalNotifications)
        ,MAP_FUNCTION(TROSIGS, enableVibrate)
        ,MAP_FUNCTION(TROSIGS, enableSound)
        
    };
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TROSIGS) {
    [TROSIGS_swft dispose];
    TROSIGS_swft = nil;
    TROSIGS_freBridge = nil;
    TROSIGS_swftBridge = nil;
    TROSIGS_funcArray = nil;
}
EXTENSION_INIT(TROSIGS)
EXTENSION_FIN(TROSIGS)
@end
