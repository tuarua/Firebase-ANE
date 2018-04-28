#import "FreMacros.h"
#import "AnalyticsANE_oc.h"

#define FRE_OBJC_BRIDGE TRFIRAN_FlashRuntimeExtensionsBridge // use unique prefix throughout to prevent clashes with other ANEs
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation AnalyticsANE_LIB
SWIFT_DECL(TRFIRAN) // use unique prefix throughout to prevent clashes with other ANEs
CONTEXT_INIT(TRFIRAN) {
    SWIFT_INITS(TRFIRAN)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFIRAN, init)
        ,MAP_FUNCTION(TRFIRAN, setUserProperty)
        ,MAP_FUNCTION(TRFIRAN, setUserId)
        ,MAP_FUNCTION(TRFIRAN, setSessionTimeoutDuration)
        ,MAP_FUNCTION(TRFIRAN, setMinimumSessionDuration)
        ,MAP_FUNCTION(TRFIRAN, setCurrentScreen)
        ,MAP_FUNCTION(TRFIRAN, setAnalyticsCollectionEnabled)
        ,MAP_FUNCTION(TRFIRAN, logEvent)
        ,MAP_FUNCTION(TRFIRAN, resetAnalyticsData)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFIRAN) {
    [TRFIRAN_swft dispose];
    TRFIRAN_swft = nil;
    TRFIRAN_freBridge = nil;
    TRFIRAN_swftBridge = nil;
    TRFIRAN_funcArray = nil;
}
EXTENSION_INIT(TRFIRAN)
EXTENSION_FIN(TRFIRAN)
@end
