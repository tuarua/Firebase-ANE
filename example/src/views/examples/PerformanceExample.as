package views.examples {
import com.tuarua.firebase.PerformanceANE;
import com.tuarua.firebase.performance.Trace;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import views.SimpleButton;

public class PerformanceExample extends Sprite implements IExample {
    private var stageWidth:Number;
    private var isInited:Boolean;
    private var btnStartTrace:SimpleButton = new SimpleButton("Start");
    private var btnStopTrace:SimpleButton = new SimpleButton("Stop");
    private var btnIncrementCounter:SimpleButton = new SimpleButton("Increment Counter");
    private var tracer:Trace;
    private var traceCnt:int = 0;

    public function PerformanceExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    private function initMenu():void {
        btnIncrementCounter.x = btnStartTrace.x = btnStopTrace.x = (stageWidth - 200) * 0.5;

        btnStartTrace.addEventListener(TouchEvent.TOUCH, onStartTraceClick);
        btnStopTrace.addEventListener(TouchEvent.TOUCH, onStopTraceClick);
        btnIncrementCounter.addEventListener(TouchEvent.TOUCH, onIncrementClick);
        btnIncrementCounter.visible = btnStopTrace.visible = false;
        btnStartTrace.y = btnStopTrace.y = StarlingRoot.GAP;

        btnIncrementCounter.y = btnStopTrace.y + StarlingRoot.GAP;

        addChild(btnStartTrace);
        addChild(btnStopTrace);
        addChild(btnIncrementCounter);

    }

    private function onIncrementClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnIncrementCounter);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            tracer.incrementMetric("hits");
        }
    }

    private function onStopTraceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnStopTrace);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            btnStartTrace.visible = true;
            btnStopTrace.visible = btnIncrementCounter.visible = false;
            tracer.stop();
        }
    }

    private function onStartTraceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnStartTrace);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            tracer = new Trace("test_trace_" + traceCnt);
            traceCnt++;
            tracer.start();
            btnIncrementCounter.visible = btnStopTrace.visible = true;
        }
    }

    public function initANE():void {
        if (isInited) return;
        PerformanceANE.isDataCollectionEnabled = true;
        PerformanceANE.init();
        isInited = true;
    }
}
}
