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
#import "FirebaseANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRFB_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation FirebaseANE_LIB
SWIFT_DECL(TRFIRFB) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFIRFB) {
    SWIFT_INITS(TRFIRFB)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRFB, init)
        ,MAP_FUNCTION(TRFIRFB, getOptions)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRFB) {
    [TRFIRFB_swft dispose];
    TRFIRFB_swft = nil;
    TRFIRFB_freBridge = nil;
    TRFIRFB_swftBridge = nil;
    TRFIRFB_funcArray = nil;
}
EXTENSION_INIT(TRFIRFB)
EXTENSION_FIN(TRFIRFB)
@end
