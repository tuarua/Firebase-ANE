#import "FreMacros.h"
#import "FirestoreANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRFS_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation FirestoreANE_LIB
SWIFT_DECL(TRFIRFS) // use unique prefix throughout to prevent clashes with other ANEs
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
        ,MAP_FUNCTION(TRFIRFS, addEventListener)
        ,MAP_FUNCTION(TRFIRFS, removeEventListener)
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
