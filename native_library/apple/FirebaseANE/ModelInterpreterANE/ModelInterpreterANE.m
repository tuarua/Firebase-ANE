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
#import "ModelInterpreterANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBMI_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation ModelInterpreterANE_LIB
SWIFT_DECL(TRFBMI)
CONTEXT_INIT(TRFBMI) {
    SWIFT_INITS(TRFBMI)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBMI, init)
        ,MAP_FUNCTION(TRFBMI, createGUID)
        ,MAP_FUNCTION(TRFBMI, run)
        ,MAP_FUNCTION(TRFBMI, registerCloudModel)
        ,MAP_FUNCTION(TRFBMI, registerLocalModel)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBMI) {
    [TRFBMI_swft dispose];
    TRFBMI_swft = nil;
    TRFBMI_freBridge = nil;
    TRFBMI_swftBridge = nil;
    TRFBMI_funcArray = nil;
}
EXTENSION_INIT(TRFBMI)
EXTENSION_FIN(TRFBMI)
@end
