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
#import "VisionFaceANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVFC_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionFaceANE_LIB
SWIFT_DECL(TRFBVFC) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVFC) {
    SWIFT_INITS(TRFBVFC)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVFC, init)
        ,MAP_FUNCTION(TRFBVFC, createGUID)
        ,MAP_FUNCTION(TRFBVFC, detect)
        ,MAP_FUNCTION(TRFBVFC, getResults)
        ,MAP_FUNCTION(TRFBVFC, close)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVFC) {
    [TRFBVFC_swft dispose];
    TRFBVFC_swft = nil;
    TRFBVFC_freBridge = nil;
    TRFBVFC_swftBridge = nil;
    TRFBVFC_funcArray = nil;
}
EXTENSION_INIT(TRFBVFC)
EXTENSION_FIN(TRFBVFC)
@end
