package com.tuarua.firebase {
import com.tuarua.firebase.auth.AuthError;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;
/** @private */
public class AuthANEContext {
    internal static const NAME:String = "AuthANE";
    internal static const TRACE:String = "TRACE";
    internal static const INIT_ERROR_MESSAGE:String = NAME + " not initialised... use .auth";
    private static var _context:ExtensionContext;
    public static var closures:Dictionary = new Dictionary();
    public static var closureCallers:Dictionary = new Dictionary();
    private static var _isInited:Boolean = false;
    private static const EMAIL_UPDATED:String = "AuthEvent.EmailUpdated";
    private static const PASSWORD_UPDATED:String = "AuthEvent.PasswordUpdated";
    private static const PROFILE_UPDATED:String = "AuthEvent.ProfileUpdated";
    private static const SIGN_IN:String = "AuthEvent.SignIn";
    private static const PASSWORD_RESET_EMAIL_SENT:String = "AuthEvent.PasswordResetEmailSent";
    private static const USER_DELETED:String = "AuthEvent.UserDeleted";
    private static const USER_REAUTHENTICATED:String = "AuthEvent.UserReauthenticated";
    private static const USER_CREATED:String = "AuthEvent.UserCreated";
    private static const USER_UNLINKED: String = "AuthEvent.UserUnlinked";
    private static const USER_LINKED: String = "AuthEvent.UserLinked";
    private static const EMAIL_VERIFICATION_SENT:String = "AuthEvent.EmailVerificationSent";
    private static const ID_TOKEN:String = "AuthEvent.OnIdToken";
    private static const PHONE_CODE_SENT:String = "AuthEvent.PhoneCodeSent";
    private static var pObj:Object;

    public function AuthANEContext() {

    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    public static function isNullOrEmpty(value:String):Boolean {
        return value == null || value == "";
    }

    public static function createEventId(listener:Function):String{
        var eventId:String;
        if (listener) {
            eventId = context.call("createGUID") as String;
            closures[eventId] = listener;
        }
        return eventId;
    }

    private static function gotEvent(event:StatusEvent):void {
        var err:AuthError;
        var closure:Function;
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case SIGN_IN:
            case PASSWORD_RESET_EMAIL_SENT:
            case EMAIL_VERIFICATION_SENT:
            case USER_CREATED:
            case USER_DELETED:
            case USER_REAUTHENTICATED:
            case EMAIL_UPDATED:
            case PASSWORD_UPDATED:
            case PROFILE_UPDATED:
            case USER_UNLINKED:
            case USER_LINKED:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new AuthError(pObj.error.text, pObj.error.id);
                    }
                    closure.call(null, err);
                    delete closures[pObj.eventId];
                    delete closureCallers[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case ID_TOKEN:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    var token:String;
                    if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("token")) {
                        token = pObj.data.token;
                    }
                    closure.call(null, token);
                    delete closures[pObj.eventId];
                    delete closureCallers[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
            case PHONE_CODE_SENT:
                try {
                    pObj = JSON.parse(event.code);
                    closure = closures[pObj.eventId];
                    if (closure == null) return;
                    if (pObj.hasOwnProperty("error") && pObj.error) {
                        err = new AuthError(pObj.error.text, pObj.error.id);
                    }
                    var verificationId:String;
                    if (pObj.hasOwnProperty("data") && pObj.data && pObj.data.hasOwnProperty("verificationId")) {
                        verificationId = pObj.data.token;
                    }
                    closure.call(null, verificationId, err);
                    delete closures[pObj.eventId];
                    delete closureCallers[pObj.eventId];
                } catch (e:Error) {
                    trace("parsing error", event.code, e.message);
                }
                break;
        }
    }

    public static function dispose():void {
        if (!_context) {
            return;
        }
        trace("[" + NAME + "] Unloading ANE...");
        _context.removeEventListener(StatusEvent.STATUS, gotEvent);
        _context.dispose();
        _context = null;
        _isInited = false;
    }

    public static function validate():void {
        if (!_isInited) throw new Error(INIT_ERROR_MESSAGE);
    }

}
}
