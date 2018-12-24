package views.examples {
import com.tuarua.firebase.MessagingANE;
import com.tuarua.firebase.messaging.RemoteMessage;
import com.tuarua.firebase.messaging.events.MessagingEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class MessagingExample extends Sprite implements IExample {
    private var stageWidth:Number;
    private var isInited:Boolean;
    private var btnLogToken:SimpleButton = new SimpleButton("Log Token");
    private var btnSubscribe:SimpleButton = new SimpleButton("Subscribe");
    private var messaging:MessagingANE;
    private var statusLabel:TextField;


    public function MessagingExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    private function initMenu():void {
        btnLogToken.x = btnSubscribe.x = (stageWidth - 200) * 0.5;
        btnLogToken.addEventListener(TouchEvent.TOUCH, onLogTokenClick);
        btnSubscribe.addEventListener(TouchEvent.TOUCH, onSubscribeClick);
        btnLogToken.y = StarlingRoot.GAP;
        btnSubscribe.y = btnLogToken.y + StarlingRoot.GAP;

        addChild(btnLogToken);
        addChild(btnSubscribe);

        statusLabel = new TextField(stageWidth, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnSubscribe.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

    }


    private function onLogTokenClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLogToken);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            trace("FCM Token: ", messaging.token);
            statusLabel.text = "FCM Token: " + messaging.token;
        }
    }


    private function onSubscribeClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnSubscribe);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            messaging.subscribe("news");
        }
    }

    public function initANE():void {
        if (isInited) return;
        MessagingANE.channelId = "fcm_default_channel";
        MessagingANE.channelName = "News";
        messaging = MessagingANE.messaging;
        messaging.addEventListener(MessagingEvent.ON_TOKEN_REFRESHED, onTokenRefreshed);
        messaging.addEventListener(MessagingEvent.ON_MESSAGE_RECEIVED, onMessageReceived);
        isInited = true;
    }

    private function onMessageReceived(event:MessagingEvent):void {
        var remoteMessage:RemoteMessage = event.remoteMessage;
        statusLabel.text = "Message Received" + "\n" +
                "From: " + remoteMessage.from + "\n" +
                "MessageId: " + remoteMessage.messageId + "\n" +
                "Sent at: " + new Date(remoteMessage.sentTime) + "\n";

        if (remoteMessage.notification) {
            statusLabel.text = statusLabel.text + "Notification Body: " + remoteMessage.notification.body + "\n" +
                    "Notification Title: " + remoteMessage.notification.title + "\n";
        }
        if (remoteMessage.data) {
            statusLabel.text = statusLabel.text + "Data: " + JSON.stringify(remoteMessage.data) + "\n";
        }
    }

    private function onTokenRefreshed(event:MessagingEvent):void {
        statusLabel.text = "FCM Refreshed Token: " + event.token;
    }

}
}
