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
#import "VisionTextANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVTX_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionTextANE_LIB
SWIFT_DECL(TRFBVTX) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVTX) {
    SWIFT_INITS(TRFBVTX)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVTX, init)
        ,MAP_FUNCTION(TRFBVTX, createGUID)
        ,MAP_FUNCTION(TRFBVTX, detect)
        ,MAP_FUNCTION(TRFBVTX, getResults)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVTX) {
    [TRFBVTX_swft dispose];
    TRFBVTX_swft = nil;
    TRFBVTX_freBridge = nil;
    TRFBVTX_swftBridge = nil;
    TRFBVTX_funcArray = nil;
}
EXTENSION_INIT(TRFBVTX)
EXTENSION_FIN(TRFBVTX)
@end
