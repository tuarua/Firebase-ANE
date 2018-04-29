package views.examples {
import com.tuarua.firebase.AnalyticsANE;
import com.tuarua.firebase.analytics.FirebaseAnalyticsEvent;
import com.tuarua.firebase.analytics.FirebaseAnalyticsParam;
import com.tuarua.utils.GUID;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class AnalyticsExample extends Sprite {
    private var analytics:AnalyticsANE;
    private var btnLogEvent:SimpleButton = new SimpleButton("Log Event");
    private var btnReset:SimpleButton = new SimpleButton("Reset Analytics Data");
    private var btnGetAppInstanceId:SimpleButton = new SimpleButton("Get AppInstanceID");
    private var statusLabel:TextField;
    private var stageWidth:Number;

    public function AnalyticsExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        analytics = AnalyticsANE.analytics;
        analytics.analyticsCollectionEnabled = true;
        analytics.currentScreen = "Home Screen";
        analytics.userId = GUID.create(); // for testing create a different user each session
        initMenu();
    }

    private function initMenu():void {
        btnGetAppInstanceId.x = btnReset.x = btnLogEvent.x = (stageWidth - 200) * 0.5;
        btnLogEvent.y = StarlingRoot.GAP;
        btnLogEvent.addEventListener(TouchEvent.TOUCH, onLogEventClick);
        addChild(btnLogEvent);

        btnReset.y = btnLogEvent.y + StarlingRoot.GAP;
        btnReset.addEventListener(TouchEvent.TOUCH, onResetClick);
        addChild(btnReset);

        btnGetAppInstanceId.y = btnReset.y + StarlingRoot.GAP;
        btnGetAppInstanceId.addEventListener(TouchEvent.TOUCH, onGetAppInstanceIdClick);
        addChild(btnGetAppInstanceId);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnGetAppInstanceId.y + 75;
        addChild(statusLabel);

    }

    private function onLogEventClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLogEvent);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var obj:Object = {};
            obj[FirebaseAnalyticsParam.ITEM_ID] = "abc";
            obj[FirebaseAnalyticsParam.ITEM_NAME] = "item name";
            obj[FirebaseAnalyticsParam.CONTENT_TYPE] = "image";
            analytics.logEvent(FirebaseAnalyticsEvent.SELECT_CONTENT, obj);
        }
    }

    private function onResetClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnReset);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            analytics.resetAnalyticsData();
        }
    }

    private function onGetAppInstanceIdClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetAppInstanceId);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            statusLabel.text = "appInstanceId: " + analytics.appInstanceId;
        }
    }

}
}
