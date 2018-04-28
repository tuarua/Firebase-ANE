package com.tuarua.firebase {
import flash.events.StatusEvent;
import flash.external.ExtensionContext;

public class AnalyticsANEContext {
    internal static const NAME:String = "AnalyticsANE";
    internal static const TRACE:String = "TRACE";
    private static var _context:ExtensionContext;
    public function AnalyticsANEContext() {
    }

    private static function gotEvent(event:StatusEvent):void {
        var pObj:Object;
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
            } catch (e:Error) {
                trace("[" + NAME + "] ANE Not loaded properly.  Future calls will fail.");
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
    }
}
}
