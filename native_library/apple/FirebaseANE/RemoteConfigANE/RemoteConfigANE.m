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
#import "RemoteConfigANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRRC_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation RemoteConfigANE_LIB
SWIFT_DECL(TRFIRRC)
CONTEXT_INIT(TRFIRRC) {
    SWIFT_INITS(TRFIRRC)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRRC, init)
        ,MAP_FUNCTION(TRFIRRC, setDefaults)
        ,MAP_FUNCTION(TRFIRRC, setConfigSettings)
        ,MAP_FUNCTION(TRFIRRC, getByteArray)
        ,MAP_FUNCTION(TRFIRRC, getBoolean)
        ,MAP_FUNCTION(TRFIRRC, getDouble)
        ,MAP_FUNCTION(TRFIRRC, getString)
        ,MAP_FUNCTION(TRFIRRC, getKeysByPrefix)
        ,MAP_FUNCTION(TRFIRRC, fetch)
        ,MAP_FUNCTION(TRFIRRC, activateFetched)
        ,MAP_FUNCTION(TRFIRRC, activate)
        ,MAP_FUNCTION(TRFIRRC, fetchAndActivate)
        ,MAP_FUNCTION(TRFIRRC, getInfo)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRRC) {
    [TRFIRRC_swft dispose];
    TRFIRRC_swft = nil;
    TRFIRRC_freBridge = nil;
    TRFIRRC_swftBridge = nil;
    TRFIRRC_funcArray = nil;
}
EXTENSION_INIT(TRFIRRC)
EXTENSION_FIN(TRFIRRC)
@end
