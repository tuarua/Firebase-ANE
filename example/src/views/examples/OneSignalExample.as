package views.examples {
import com.tuarua.OneSignal;
import com.tuarua.onesignal.LogLevel;
import com.tuarua.onesignal.OSEmailSubscriptionState;
import com.tuarua.onesignal.OSNotificationDisplayType;
import com.tuarua.onesignal.OSPermissionState;
import com.tuarua.onesignal.OSPermissionSubscriptionState;
import com.tuarua.onesignal.OSSubscriptionState;
import com.tuarua.onesignal.events.EmailSubscriptionEvent;
import com.tuarua.onesignal.events.IdsEvent;
import com.tuarua.onesignal.events.NotificationEvent;
import com.tuarua.onesignal.events.PermissionEvent;
import com.tuarua.onesignal.events.SubscriptionEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class OneSignalExample extends Sprite implements IExample {
    private var stageWidth:Number;
    private var isInited:Boolean;
    private var oneSignal:OneSignal;
    private var btnDetails:SimpleButton = new SimpleButton("Get Details");
    private var btnPermissions:SimpleButton = new SimpleButton("Get Permission States");
    private var btnSetEmail:SimpleButton = new SimpleButton("Set Email");
    private var statusLabel:TextField;

    public function OneSignalExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    private function initMenu():void {
        btnSetEmail.x = btnDetails.x = btnPermissions.x = (stageWidth - 200) * 0.5;
        btnDetails.addEventListener(TouchEvent.TOUCH, onLogTokenClick);
        btnPermissions.addEventListener(TouchEvent.TOUCH, onSubscribeClick);
        btnSetEmail.addEventListener(TouchEvent.TOUCH, onSetEmailClick);
        btnDetails.y = StarlingRoot.GAP;
        btnPermissions.y = btnDetails.y + StarlingRoot.GAP;
        btnSetEmail.y = btnPermissions.y + StarlingRoot.GAP;

        addChild(btnDetails);
        addChild(btnPermissions);
        addChild(btnSetEmail);


        statusLabel = new TextField(stageWidth, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnSetEmail.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

    }

    private function onSetEmailClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnSetEmail);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            oneSignal.setEmail("test@test.com");
        }
    }

    private function onLogTokenClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDetails);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            trace("One Signal Version: ", OneSignal.version);
            trace("One Signal sdkType: ", OneSignal.sdkType);
            statusLabel.text += "One Signal Version: " + OneSignal.version + "\n";
        }
    }

    private function onSubscribeClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPermissions);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var state:OSPermissionSubscriptionState = oneSignal.getPermissionSubscriptionState();
            trace(state);
            trace("");
        }
    }

    public function initANE():void {
        if (isInited) return;
        oneSignal = OneSignal.shared();
        oneSignal.addEventListener(IdsEvent.ON_AVAILABLE, onIdsAvailable);
        oneSignal.addEventListener(SubscriptionEvent.ON_CHANGE, onSubscriptionChange);
        oneSignal.addEventListener(EmailSubscriptionEvent.ON_CHANGE, onEmailSubscriptionChange);
        oneSignal.addEventListener(PermissionEvent.ON_CHANGE, onPermissionChange);
        oneSignal.addEventListener(NotificationEvent.RECEIVED, onNotificationReceived);
        oneSignal.addEventListener(NotificationEvent.OPENED, onNotificationOpened);
        oneSignal.setLogLevel(LogLevel.debug, LogLevel.none);
        oneSignal.init("");
        oneSignal.setInFocusDisplaying(OSNotificationDisplayType.inAppAlert);
        isInited = true;
    }

    private function onNotificationOpened(event:NotificationEvent):void {
        trace(event.result);
    }

    private function onNotificationReceived(event:NotificationEvent):void {
        trace(event.notification);
    }

    private function onPermissionChange(event:PermissionEvent):void {
        var fromState:OSPermissionState = event.from;
        var toState:OSPermissionState = event.to;

        trace("EmailSubscription from: ***********");
        trace("enabled:", fromState.enabled);
        trace("hasPrompted:", fromState.hasPrompted);
        trace("providesAppNotificationSettings:", fromState.providesAppNotificationSettings);
        trace("reachable:", fromState.reachable);
        trace("status:", fromState.status);

        trace("EmailSubscription to: ***********");
        trace("enabled:", toState.enabled);
        trace("hasPrompted:", toState.hasPrompted);
        trace("providesAppNotificationSettings:", toState.providesAppNotificationSettings);
        trace("reachable:", toState.reachable);
        trace("status:", toState.status);
    }

    private function onEmailSubscriptionChange(event:EmailSubscriptionEvent):void {
        var fromState:OSEmailSubscriptionState = event.from;
        var toState:OSEmailSubscriptionState = event.to;

        trace("EmailSubscription from: ***********");
        trace("emailAddress:", fromState.emailAddress);
        trace("emailUserId:", fromState.emailUserId);
        trace("subscribed:", fromState.subscribed);

        trace("EmailSubscription to: ***********");
        trace("emailAddress:", toState.emailAddress);
        trace("emailUserId:", toState.emailUserId);
        trace("subscribed:", toState.subscribed);

    }

    private function onSubscriptionChange(event:SubscriptionEvent):void {
        var fromState:OSSubscriptionState = event.from;
        var toState:OSSubscriptionState = event.to;

        trace("Subscription from: ***********");
        trace("userId:", fromState.userId);
        trace("pushToken:", fromState.pushToken);
        trace("subscribed:", fromState.subscribed);
        trace("userSubscriptionSetting:", fromState.userSubscriptionSetting);

        trace("Subscription to: ***********");
        trace("userId:", toState.userId);
        trace("pushToken:", toState.pushToken);
        trace("subscribed:", toState.subscribed);
        trace("userSubscriptionSetting:", toState.userSubscriptionSetting);
    }

    private function onIdsAvailable(event:IdsEvent):void {
        statusLabel.text += "onIdsAvailable: " + event.userId + "-" + event.registrationId + "\n";
    }

}
}