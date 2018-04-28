package com.tuarua.firebase {
import com.tuarua.firebase.auth.AuthError;
import com.tuarua.firebase.auth.events.AuthErrorEvent;
import com.tuarua.firebase.auth.events.AuthEvent;
import com.tuarua.utils.GUID;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.Dictionary;

public class AuthANEContext {
    internal static const NAME:String = "AuthANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    public function AuthANEContext() {

    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
            }
        }
        return _context;
    }

    private static function gotEvent(event:StatusEvent):void {
        var pObj:Object;
        //trace(event.code);
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
            case AuthEvent.SIGN_IN:
            case AuthEvent.PASSWORD_RESET_EMAIL_SENT:
            case AuthEvent.EMAIL_VERIFICATION_SENT:
            case AuthEvent.USER_CREATED:
            case AuthEvent.USER_DELETED:
            case AuthEvent.USER_REAUTHENTICATED:
                AuthANE.auth.dispatchEvent(new AuthEvent(event.level));
                break;
            case AuthErrorEvent.EMAIL_VERIFICATION_SENT_ERROR:
            case AuthErrorEvent.USER_REAUTHENTICATED_ERROR:
            case AuthErrorEvent.USER_DELETED_ERROR:
            case AuthErrorEvent.USER_CREATED_ERROR:
            case AuthErrorEvent.SIGN_IN_ERROR:
            case AuthErrorEvent.SIGN_OUT_ERROR:
            case AuthErrorEvent.PASSWORD_RESET_EMAIL_SENT_ERROR:
                try {
                    pObj = JSON.parse(event.code);
                    AuthANE.auth.dispatchEvent(new AuthErrorEvent(event.level, true, false, pObj.text, pObj.id));
                } catch (e:Error) {
                    trace(e.message);
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
    }

}
}
