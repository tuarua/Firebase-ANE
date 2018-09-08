package com.tuarua.firebase {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
/** @private */
public class AnalyticsANEContext {
    internal static const NAME:String = "AnalyticsANE";
    internal static const TRACE:String = "TRACE";
    private static const INIT_ERROR_MESSAGE:String = NAME + "... use .analytics";
    private static var _context:ExtensionContext;
    private static var _isInited:Boolean = false;
    public function AnalyticsANEContext() {
    }

    private static function gotEvent(event:StatusEvent):void {
        switch (event.level) {
            case TRACE:
                trace("[" + NAME + "]", event.code);
                break;
        }
    }

    public static function get context():ExtensionContext {
        if (_context == null) {
            try {
                _context = ExtensionContext.createExtensionContext("com.tuarua.firebase." + NAME, null);
                _context.addEventListener(StatusEvent.STATUS, gotEvent);
                _isInited = true;
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly. Future calls will fail.");
            }
        }
        return _context;
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
