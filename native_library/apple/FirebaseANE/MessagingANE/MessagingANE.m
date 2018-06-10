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
#import "MessagingANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRMS_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation MessagingANE_LIB
SWIFT_DECL(TRFIRMS) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFIRMS) {
    SWIFT_INITS(TRFIRMS)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRMS, init)
        ,MAP_FUNCTION(TRFIRMS, createGUID)
        ,MAP_FUNCTION(TRFIRMS, getToken)
        ,MAP_FUNCTION(TRFIRMS, subscribe)
        ,MAP_FUNCTION(TRFIRMS, unsubscribe)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRMS) {
    [TRFIRMS_swft dispose];
    TRFIRMS_swft = nil;
    TRFIRMS_freBridge = nil;
    TRFIRMS_swftBridge = nil;
    TRFIRMS_funcArray = nil;
}
EXTENSION_INIT(TRFIRMS)
EXTENSION_FIN(TRFIRMS)
@end
