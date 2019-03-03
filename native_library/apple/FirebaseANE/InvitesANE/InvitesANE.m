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
#import "InvitesANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRIV_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation InvitesANE_LIB
SWIFT_DECL(TRFIRIV)
CONTEXT_INIT(TRFIRIV) {
    SWIFT_INITS(TRFIRIV)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRIV, init)
        ,MAP_FUNCTION(TRFIRIV, createGUID)
        ,MAP_FUNCTION(TRFIRIV, openInvite)
        ,MAP_FUNCTION(TRFIRIV, getDynamicLink)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRIV) {
    [TRFIRIV_swft dispose];
    TRFIRIV_swft = nil;
    TRFIRIV_freBridge = nil;
    TRFIRIV_swftBridge = nil;
    TRFIRIV_funcArray = nil;
}
EXTENSION_INIT(TRFIRIV)
EXTENSION_FIN(TRFIRIV)
@end
