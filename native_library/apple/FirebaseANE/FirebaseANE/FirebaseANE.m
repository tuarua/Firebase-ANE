#import "FreMacros.h"
#import "FirebaseANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRFB_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation FirebaseANE_LIB
SWIFT_DECL(TRFIRFB) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFIRFB) {
    SWIFT_INITS(TRFIRFB)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRFB, init)
        ,MAP_FUNCTION(TRFIRFB, getOptions)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRFB) {
    [TRFIRFB_swft dispose];
    TRFIRFB_swft = nil;
    TRFIRFB_freBridge = nil;
    TRFIRFB_swftBridge = nil;
    TRFIRFB_funcArray = nil;
}
EXTENSION_INIT(TRFIRFB)
EXTENSION_FIN(TRFIRFB)
@end
