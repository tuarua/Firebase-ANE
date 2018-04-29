#import "FreMacros.h"
#import "RemoteConfigANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRRC_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation RemoteConfigANE_LIB
SWIFT_DECL(TRFIRRC) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFIRRC) {
    SWIFT_INITS(TRFIRRC)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRRC, init)
        ,MAP_FUNCTION(TRFIRRC, setDefaults)
        ,MAP_FUNCTION(TRFIRRC, setConfigSettings)
        ,MAP_FUNCTION(TRFIRRC, getByteArray)
        ,MAP_FUNCTION(TRFIRRC, getBoolean)
        ,MAP_FUNCTION(TRFIRRC, getDouble)
        ,MAP_FUNCTION(TRFIRRC, getString)
        ,MAP_FUNCTION(TRFIRRC, getKeysByPrefix)
        ,MAP_FUNCTION(TRFIRRC, fetch)
        ,MAP_FUNCTION(TRFIRRC, activateFetched)
        ,MAP_FUNCTION(TRFIRRC, getInfo)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRRC) {
    [TRFIRRC_swft dispose];
    TRFIRRC_swft = nil;
    TRFIRRC_freBridge = nil;
    TRFIRRC_swftBridge = nil;
    TRFIRRC_funcArray = nil;
}
EXTENSION_INIT(TRFIRRC)
EXTENSION_FIN(TRFIRRC)
@end
