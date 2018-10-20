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
#import "VisionLabelANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVLB_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionLabelANE_LIB
SWIFT_DECL(TRFBVLB) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVLB) {
    SWIFT_INITS(TRFBVLB)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVLB, init)
        ,MAP_FUNCTION(TRFBVLB, createGUID)
        ,MAP_FUNCTION(TRFBVLB, detect)
        ,MAP_FUNCTION(TRFBVLB, getResults)
        ,MAP_FUNCTION(TRFBVLB, close)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVLB) {
    [TRFBVLB_swft dispose];
    TRFBVLB_swft = nil;
    TRFBVLB_freBridge = nil;
    TRFBVLB_swftBridge = nil;
    TRFBVLB_funcArray = nil;
}
EXTENSION_INIT(TRFBVLB)
EXTENSION_FIN(TRFBVLB)
@end
