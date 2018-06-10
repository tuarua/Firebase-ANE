package views.examples {
import com.tuarua.firebase.RemoteConfigANE;
import com.tuarua.firebase.remoteconfig.RemoteConfigSettings;
import com.tuarua.firebase.remoteconfig.events.RemoteConfigEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class RemoteConfigExample extends Sprite implements IExample {
    private var remoteConfig:RemoteConfigANE;
    private var stageWidth:Number;
    private var statusLabel:TextField;
    private var btnGetWelcomeMessage:SimpleButton = new SimpleButton("Get Welcome Message");
    private var isInited:Boolean;

    public function RemoteConfigExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;

        remoteConfig = RemoteConfigANE.remoteConfig;
        remoteConfig.configSettings = new RemoteConfigSettings(true);
        remoteConfig.addEventListener(RemoteConfigEvent.FETCH, onRemoteConfig);
        remoteConfig.setDefaults(
                {
                    "welcome_message_caps": false,
                    "welcome_message": "I am a default message"
                }
        );

        var message:String = remoteConfig.getString("welcome_message");
        if (remoteConfig.getBoolean("welcome_message_caps")) {
            message = message.toUpperCase();
        }
        statusLabel.text = message;

        isInited = true;
    }

    private function initMenu():void {
        statusLabel = new TextField(stageWidth - 100, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.wordWrap = true;
        statusLabel.touchable = false;
        statusLabel.x = 50;

        addChild(statusLabel);
        btnGetWelcomeMessage.x = (stageWidth - 200) * 0.5;
        btnGetWelcomeMessage.y = StarlingRoot.GAP;
        btnGetWelcomeMessage.addEventListener(TouchEvent.TOUCH, onGetWelcomeMessageClick);
        addChild(btnGetWelcomeMessage);

        statusLabel.y = btnGetWelcomeMessage.y + (StarlingRoot.GAP * 1.25);


    }

    private function onGetWelcomeMessageClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetWelcomeMessage);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            remoteConfig.fetch(0);
        }
    }

    private function onRemoteConfig(event:RemoteConfigEvent):void {
        remoteConfig.activateFetched();
        var message:String = remoteConfig.getString("welcome_message");
        if (remoteConfig.getBoolean("welcome_message_caps")) {
            message = message.toUpperCase();
        }
        statusLabel.text = message;
    }
}
}
