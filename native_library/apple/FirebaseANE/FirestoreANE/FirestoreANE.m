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
#import "FirestoreANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRFS_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation FirestoreANE_LIB
SWIFT_DECL(TRFIRFS)
CONTEXT_INIT(TRFIRFS) {
    SWIFT_INITS(TRFIRFS)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRFS, init)
        ,MAP_FUNCTION(TRFIRFS, createGUID)
        ,MAP_FUNCTION(TRFIRFS, getFirestoreSettings)
        ,MAP_FUNCTION(TRFIRFS, getDocuments)
        ,MAP_FUNCTION(TRFIRFS, initDocumentReference)
        ,MAP_FUNCTION(TRFIRFS, getDocumentReference)
        ,MAP_FUNCTION(TRFIRFS, setDocumentReference)
        ,MAP_FUNCTION(TRFIRFS, updateDocumentReference)
        ,MAP_FUNCTION(TRFIRFS, deleteDocumentReference)
        ,MAP_FUNCTION(TRFIRFS, getDocumentParent)
        ,MAP_FUNCTION(TRFIRFS, documentWithAutoId)
        ,MAP_FUNCTION(TRFIRFS, initCollectionReference)
        ,MAP_FUNCTION(TRFIRFS, getCollectionParent)
        ,MAP_FUNCTION(TRFIRFS, addSnapshotListenerDocument)
        ,MAP_FUNCTION(TRFIRFS, removeSnapshotListener)
        ,MAP_FUNCTION(TRFIRFS, startBatch)
        ,MAP_FUNCTION(TRFIRFS, commitBatch)
        ,MAP_FUNCTION(TRFIRFS, setBatch)
        ,MAP_FUNCTION(TRFIRFS, updateBatch)
        ,MAP_FUNCTION(TRFIRFS, deleteBatch)
        ,MAP_FUNCTION(TRFIRFS, enableNetwork)
        ,MAP_FUNCTION(TRFIRFS, disableNetwork)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRFS) {
    [TRFIRFS_swft dispose];
    TRFIRFS_swft = nil;
    TRFIRFS_freBridge = nil;
    TRFIRFS_swftBridge = nil;
    TRFIRFS_funcArray = nil;
}
EXTENSION_INIT(TRFIRFS)
EXTENSION_FIN(TRFIRFS)
@end
