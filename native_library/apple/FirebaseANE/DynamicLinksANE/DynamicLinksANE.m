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
#import "DynamicLinksANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRDL_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation DynamicLinksANE_LIB
SWIFT_DECL(TRFIRDL)
CONTEXT_INIT(TRFIRDL) {
    SWIFT_INITS(TRFIRDL)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRDL, init)
        ,MAP_FUNCTION(TRFIRDL, createGUID)
        ,MAP_FUNCTION(TRFIRDL, buildDynamicLink)
        ,MAP_FUNCTION(TRFIRDL, getDynamicLink)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRDL) {
    [TRFIRDL_swft dispose];
    TRFIRDL_swft = nil;
    TRFIRDL_freBridge = nil;
    TRFIRDL_swftBridge = nil;
    TRFIRDL_funcArray = nil;
}
EXTENSION_INIT(TRFIRDL)
EXTENSION_FIN(TRFIRDL)
@end
