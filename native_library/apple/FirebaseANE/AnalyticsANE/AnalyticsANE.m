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
#import "AnalyticsANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRAN_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation AnalyticsANE_LIB
SWIFT_DECL(TRFIRAN)
CONTEXT_INIT(TRFIRAN) {
    SWIFT_INITS(TRFIRAN)
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRAN, init)
        ,MAP_FUNCTION(TRFIRAN, getAppInstanceId)
        ,MAP_FUNCTION(TRFIRAN, setUserProperty)
        ,MAP_FUNCTION(TRFIRAN, setUserId)
        ,MAP_FUNCTION(TRFIRAN, setSessionTimeoutDuration)
        ,MAP_FUNCTION(TRFIRAN, setCurrentScreen)
        ,MAP_FUNCTION(TRFIRAN, setAnalyticsCollectionEnabled)
        ,MAP_FUNCTION(TRFIRAN, logEvent)
        ,MAP_FUNCTION(TRFIRAN, resetAnalyticsData)
    };
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRAN) {
    [TRFIRAN_swft dispose];
    TRFIRAN_swft = nil;
    TRFIRAN_freBridge = nil;
    TRFIRAN_swftBridge = nil;
    TRFIRAN_funcArray = nil;
}
EXTENSION_INIT(TRFIRAN)
EXTENSION_FIN(TRFIRAN)
@end
