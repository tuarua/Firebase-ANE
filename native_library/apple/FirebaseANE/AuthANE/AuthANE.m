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
#import "AuthANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRAU_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation AuthANE_LIB
SWIFT_DECL(TRFIRAU)
CONTEXT_INIT(TRFIRAU) {
    SWIFT_INITS(TRFIRAU)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRAU, init)
        ,MAP_FUNCTION(TRFIRAU, createGUID)
        ,MAP_FUNCTION(TRFIRAU, createUserWithEmailAndPassword)
        ,MAP_FUNCTION(TRFIRAU, signIn)
        ,MAP_FUNCTION(TRFIRAU, signInAnonymously)
        ,MAP_FUNCTION(TRFIRAU, signInWithCustomToken)
        ,MAP_FUNCTION(TRFIRAU, updateProfile)
        ,MAP_FUNCTION(TRFIRAU, signOut)
        ,MAP_FUNCTION(TRFIRAU, sendEmailVerification)
        ,MAP_FUNCTION(TRFIRAU, updateEmail)
        ,MAP_FUNCTION(TRFIRAU, updatePassword)
        ,MAP_FUNCTION(TRFIRAU, sendPasswordResetEmail)
        ,MAP_FUNCTION(TRFIRAU, deleteUser)
        ,MAP_FUNCTION(TRFIRAU, reauthenticate)
        ,MAP_FUNCTION(TRFIRAU, unlink)
        ,MAP_FUNCTION(TRFIRAU, link)
        ,MAP_FUNCTION(TRFIRAU, setLanguageCode)
        ,MAP_FUNCTION(TRFIRAU, getLanguageCode)
        ,MAP_FUNCTION(TRFIRAU, getCurrentUser)
        ,MAP_FUNCTION(TRFIRAU, getIdToken)
        ,MAP_FUNCTION(TRFIRAU, reload)
        ,MAP_FUNCTION(TRFIRAU, verifyPhoneNumber)  
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRAU) {
    [TRFIRAU_swft dispose];
    TRFIRAU_swft = nil;
    TRFIRAU_freBridge = nil;
    TRFIRAU_swftBridge = nil;
    TRFIRAU_funcArray = nil;
}
EXTENSION_INIT(TRFIRAU)
EXTENSION_FIN(TRFIRAU)
@end
