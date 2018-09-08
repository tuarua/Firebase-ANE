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
#import "VisionBarcodeANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVBC_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
    @end
@implementation FRE_OBJC_BRIDGE {
}
    FRE_OBJC_BRIDGE_FUNCS
    @end

@implementation VisionBarcodeANE_LIB
SWIFT_DECL(TRFBVBC) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVBC) {
    SWIFT_INITS(TRFBVBC)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVBC, init)
        ,MAP_FUNCTION(TRFBVBC, createGUID)
        ,MAP_FUNCTION(TRFBVBC, detect)
        ,MAP_FUNCTION(TRFBVBC, getResults)
        ,MAP_FUNCTION(TRFBVBC, isCameraSupported)
        ,MAP_FUNCTION(TRFBVBC, inputFromCamera)
        ,MAP_FUNCTION(TRFBVBC, closeCamera)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVBC) {
    [TRFBVBC_swft dispose];
    TRFBVBC_swft = nil;
    TRFBVBC_freBridge = nil;
    TRFBVBC_swftBridge = nil;
    TRFBVBC_funcArray = nil;
}
EXTENSION_INIT(TRFBVBC)
EXTENSION_FIN(TRFBVBC)
@end
