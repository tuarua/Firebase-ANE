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
#import "StorageANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRST_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation StorageANE_LIB
    SWIFT_DECL(TRFIRST)
    CONTEXT_INIT(TRFIRST) {
        SWIFT_INITS(TRFIRST)
        
        /**************************************************************************/
        /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
        /**************************************************************************/
        
        static FRENamedFunction extensionFunctions[] =
        {
             MAP_FUNCTION(TRFIRST, init)
            ,MAP_FUNCTION(TRFIRST, createGUID)
            ,MAP_FUNCTION(TRFIRST, getReference)
            ,MAP_FUNCTION(TRFIRST, getFile)
            ,MAP_FUNCTION(TRFIRST, getParent)
            ,MAP_FUNCTION(TRFIRST, getRoot)
            ,MAP_FUNCTION(TRFIRST, deleteReference)
            ,MAP_FUNCTION(TRFIRST, putBytes)
            ,MAP_FUNCTION(TRFIRST, putFile)
            ,MAP_FUNCTION(TRFIRST, getDownloadUrl)
            ,MAP_FUNCTION(TRFIRST, getBytes)
            ,MAP_FUNCTION(TRFIRST, getMetadata)
            ,MAP_FUNCTION(TRFIRST, updateMetadata)
            ,MAP_FUNCTION(TRFIRST, pauseTask)
            ,MAP_FUNCTION(TRFIRST, resumeTask)
            ,MAP_FUNCTION(TRFIRST, cancelTask)
            ,MAP_FUNCTION(TRFIRST, getMaxDownloadRetryTime)
            ,MAP_FUNCTION(TRFIRST, getMaxUploadRetryTime)
            ,MAP_FUNCTION(TRFIRST, getMaxOperationRetryTime)
            ,MAP_FUNCTION(TRFIRST, setMaxDownloadRetryTime)
            ,MAP_FUNCTION(TRFIRST, setMaxUploadRetryTime)
            ,MAP_FUNCTION(TRFIRST, setMaxOperationRetryTime)
            ,MAP_FUNCTION(TRFIRST, addEventListener)
            ,MAP_FUNCTION(TRFIRST, removeEventListener)
        };
        
        /**************************************************************************/
        /**************************************************************************/
        
        SET_FUNCTIONS
        
    }
    
    CONTEXT_FIN(TRFIRST) {
        [TRFIRST_swft dispose];
        TRFIRST_swft = nil;
        TRFIRST_freBridge = nil;
        TRFIRST_swftBridge = nil;
        TRFIRST_funcArray = nil;
    }
    EXTENSION_INIT(TRFIRST)
    EXTENSION_FIN(TRFIRST)
    @end
