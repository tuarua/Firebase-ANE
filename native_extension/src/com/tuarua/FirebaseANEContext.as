package com.tuarua {
import com.tuarua.fre.ANEUtils;

import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class FirebaseANEContext {
    internal static const NAME:String = "FirebaseANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    public function FirebaseANEContext() {
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
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
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
