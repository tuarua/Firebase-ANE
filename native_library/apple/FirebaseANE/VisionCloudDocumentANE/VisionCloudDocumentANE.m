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
#import "VisionCloudDocumentANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBVCDC_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation VisionCloudDocumentANE_LIB
SWIFT_DECL(TRFBVCDC) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFBVCDC) {
    SWIFT_INITS(TRFBVCDC)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBVCDC, init)
        ,MAP_FUNCTION(TRFBVCDC, createGUID)
        ,MAP_FUNCTION(TRFBVCDC, detect)
        ,MAP_FUNCTION(TRFBVCDC, getResults)
        ,MAP_FUNCTION(TRFBVCDC, getBlocks)
        ,MAP_FUNCTION(TRFBVCDC, getParagraphs)
        ,MAP_FUNCTION(TRFBVCDC, getWords)
        ,MAP_FUNCTION(TRFBVCDC, getSymbols)
        ,MAP_FUNCTION(TRFBVCDC, disposeResult)
        ,MAP_FUNCTION(TRFBVCDC, close)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBVCDC) {
    [TRFBVCDC_swft dispose];
    TRFBVCDC_swft = nil;
    TRFBVCDC_freBridge = nil;
    TRFBVCDC_swftBridge = nil;
    TRFBVCDC_funcArray = nil;
}
EXTENSION_INIT(TRFBVCDC)
EXTENSION_FIN(TRFBVCDC)
@end
