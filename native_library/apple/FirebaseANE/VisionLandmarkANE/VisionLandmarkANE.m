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
#import "VisionLandmarkANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVLM_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionLandmarkANE_LIB
SWIFT_DECL(TRFBVLM) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVLM) {
    SWIFT_INITS(TRFBVLM)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVLM, init)
        ,MAP_FUNCTION(TRFBVLM, createGUID)
        ,MAP_FUNCTION(TRFBVLM, detect)
        ,MAP_FUNCTION(TRFBVLM, getResults)
        ,MAP_FUNCTION(TRFBVLM, close)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVLM) {
    [TRFBVLM_swft dispose];
    TRFBVLM_swft = nil;
    TRFBVLM_freBridge = nil;
    TRFBVLM_swftBridge = nil;
    TRFBVLM_funcArray = nil;
}
EXTENSION_INIT(TRFBVLM)
EXTENSION_FIN(TRFBVLM)
@end
