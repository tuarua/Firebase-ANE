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
#import "VisionCloudLabelANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVCLB_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionCloudLabelANE_LIB
SWIFT_DECL(TRFBVCLB) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVCLB) {
    SWIFT_INITS(TRFBVCLB)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVCLB, init)
        ,MAP_FUNCTION(TRFBVCLB, createGUID)
        ,MAP_FUNCTION(TRFBVCLB, detect)
        ,MAP_FUNCTION(TRFBVCLB, getResults)
        ,MAP_FUNCTION(TRFBVCLB, close)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVCLB) {
    [TRFBVCLB_swft dispose];
    TRFBVCLB_swft = nil;
    TRFBVCLB_freBridge = nil;
    TRFBVCLB_swftBridge = nil;
    TRFBVCLB_funcArray = nil;
}
EXTENSION_INIT(TRFBVCLB)
EXTENSION_FIN(TRFBVCLB)
@end
