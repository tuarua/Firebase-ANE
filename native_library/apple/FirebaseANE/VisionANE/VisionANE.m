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
#import "VisionANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVIS_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionANE_LIB
SWIFT_DECL(TRFBVIS) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVIS) {
    SWIFT_INITS(TRFBVIS)
    static FRENamedFunction extensionFunctions[] =
    {
        MAP_FUNCTION(TRFBVIS, init)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVIS) {
    [TRFBVIS_swft dispose];
    TRFBVIS_swft = nil;
    TRFBVIS_freBridge = nil;
    TRFBVIS_swftBridge = nil;
    TRFBVIS_funcArray = nil;
}
EXTENSION_INIT(TRFBVIS)
EXTENSION_FIN(TRFBVIS)
@end
