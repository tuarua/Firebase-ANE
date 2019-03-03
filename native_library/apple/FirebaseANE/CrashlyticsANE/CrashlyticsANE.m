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
#import "CrashlyticsANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRCSH_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation CrashlyticsANE_LIB
SWIFT_DECL(TRFIRCSH)
CONTEXT_INIT(TRFIRCSH) {
    SWIFT_INITS(TRFIRCSH)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRCSH, init)
        ,MAP_FUNCTION(TRFIRCSH, createGUID)
        ,MAP_FUNCTION(TRFIRCSH, crash)
        ,MAP_FUNCTION(TRFIRCSH, log)
        ,MAP_FUNCTION(TRFIRCSH, logException)
        ,MAP_FUNCTION(TRFIRCSH, setUserIdentifier)
        ,MAP_FUNCTION(TRFIRCSH, setUserEmail)
        ,MAP_FUNCTION(TRFIRCSH, setUserName)
        ,MAP_FUNCTION(TRFIRCSH, setString)
        ,MAP_FUNCTION(TRFIRCSH, setBool)
        ,MAP_FUNCTION(TRFIRCSH, setDouble)
        ,MAP_FUNCTION(TRFIRCSH, setInt)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRCSH) {
    [TRFIRCSH_swft dispose];
    TRFIRCSH_swft = nil;
    TRFIRCSH_freBridge = nil;
    TRFIRCSH_swftBridge = nil;
    TRFIRCSH_funcArray = nil;
}
EXTENSION_INIT(TRFIRCSH)
EXTENSION_FIN(TRFIRCSH)
@end
