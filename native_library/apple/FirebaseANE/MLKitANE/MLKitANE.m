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
#import "MLKitANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBMLK_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation MLKitANE_LIB
SWIFT_DECL(TRFBMLK)
CONTEXT_INIT(TRFBMLK) {
    SWIFT_INITS(TRFBMLK)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBMLK, init)
        ,MAP_FUNCTION(TRFBMLK, createGUID)
        ,MAP_FUNCTION(TRFBMLK, requestPermissions)
        ,MAP_FUNCTION(TRFBMLK, isCameraSupported)
        ,MAP_FUNCTION(TRFBMLK, addNativeChild)
        ,MAP_FUNCTION(TRFBMLK, updateNativeChild)
        ,MAP_FUNCTION(TRFBMLK, removeNativeChild)
    };
    SET_FUNCTIONS
}

CONTEXT_FIN(TRFBMLK) {
    [TRFBMLK_swft dispose];
    TRFBMLK_swft = nil;
    TRFBMLK_freBridge = nil;
    TRFBMLK_swftBridge = nil;
    TRFBMLK_funcArray = nil;
}
EXTENSION_INIT(TRFBMLK)
EXTENSION_FIN(TRFBMLK)
@end
