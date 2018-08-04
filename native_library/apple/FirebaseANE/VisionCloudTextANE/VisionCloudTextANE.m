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
#import "VisionCloudTextANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVCTX_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionCloudTextANE_LIB
SWIFT_DECL(TRFBVCTX) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVCTX) {
    SWIFT_INITS(TRFBVCTX)
    static FRENamedFunction extensionFunctions[] =
    {
        MAP_FUNCTION(TRFBVCTX, init)
        ,MAP_FUNCTION(TRFBVCTX, createGUID)
        ,MAP_FUNCTION(TRFBVCTX, detect)
        ,MAP_FUNCTION(TRFBVCTX, getResults)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVCTX) {
    [TRFBVCTX_swft dispose];
    TRFBVCTX_swft = nil;
    TRFBVCTX_freBridge = nil;
    TRFBVCTX_swftBridge = nil;
    TRFBVCTX_funcArray = nil;
}
EXTENSION_INIT(TRFBVCTX)
EXTENSION_FIN(TRFBVCTX)
@end
