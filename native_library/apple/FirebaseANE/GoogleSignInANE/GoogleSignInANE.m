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
#import "GoogleSignInANE_oc.h"

#define FRE_OBJC_BRIDGE TRGSI_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation GoogleSignInANE_LIB
SWIFT_DECL(TRGSI)
CONTEXT_INIT(TRGSI) {
    SWIFT_INITS(TRGSI)
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRGSI, init)
        ,MAP_FUNCTION(TRGSI, createGUID)
        ,MAP_FUNCTION(TRGSI, signIn)
        ,MAP_FUNCTION(TRGSI, signInSilently)
        ,MAP_FUNCTION(TRGSI, signOut)
        ,MAP_FUNCTION(TRGSI, revokeAccess)
        ,MAP_FUNCTION(TRGSI, handle)
    };
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRGSI) {
    [TRGSI_swft dispose];
    TRGSI_swft = nil;
    TRGSI_freBridge = nil;
    TRGSI_swftBridge = nil;
    TRGSI_funcArray = nil;
}
EXTENSION_INIT(TRGSI)
EXTENSION_FIN(TRGSI)
@end
