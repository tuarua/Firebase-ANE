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
#import "NaturalLanguageANE_oc.h"

#define FRE_OBJC_BRIDGE TRFBNL_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation NaturalLanguageANE_LIB
SWIFT_DECL(TRFBNL)
CONTEXT_INIT(TRFBNL) {
    SWIFT_INITS(TRFBNL)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBNL, init)
        ,MAP_FUNCTION(TRFBNL, createGUID)
        ,MAP_FUNCTION(TRFBNL, identifyLanguage)
        ,MAP_FUNCTION(TRFBNL, identifyPossibleLanguages)
        ,MAP_FUNCTION(TRFBNL, getResults)
        ,MAP_FUNCTION(TRFBNL, getResultsMulti)
        ,MAP_FUNCTION(TRFBNL, close)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBNL) {
    [TRFBNL_swft dispose];
    TRFBNL_swft = nil;
    TRFBNL_freBridge = nil;
    TRFBNL_swftBridge = nil;
    TRFBNL_funcArray = nil;
}
EXTENSION_INIT(TRFBNL)
EXTENSION_FIN(TRFBNL)
@end
