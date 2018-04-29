package {
import com.tuarua.FirebaseANE;
import com.tuarua.firebase.AnalyticsANE;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.FirestoreANE;
import com.tuarua.firebase.RemoteConfigANE;
import com.tuarua.fre.ANEError;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Sprite;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import views.SimpleButton;
import views.examples.AnalyticsExample;
import views.examples.FirestoreExample;
import views.examples.RemoteConfigExample;
import views.examples.StorageExample;

// https://dandar3.github.io/android/google-services-json-to-xml.html

public class StarlingRoot extends Sprite {
    private var btnAnalytics:SimpleButton = new SimpleButton("Analytics");
    private var btnFirestore:SimpleButton = new SimpleButton("Firestore");
    private var btnStorage:SimpleButton = new SimpleButton("Storage");
    private var btnRemoteConfig:SimpleButton = new SimpleButton("Remote Config");

    private var btnBack:SimpleButton = new SimpleButton("Back");
    private var menuContainer:Sprite = new Sprite();

    public static const GAP:int = 60;
    private var analyticsExample:AnalyticsExample;
    private var firestoreExample:FirestoreExample;
    private var storageExample:StorageExample;
    private var remoteConfigExample:RemoteConfigExample;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        initMenu();

        try {
            FirebaseANE.init();

            var fo:FirebaseOptions = FirebaseANE.options;
            if (fo) {
                trace("apiKey", fo.apiKey);
                trace("googleAppId", fo.googleAppId);
                trace("storageBucket", fo.storageBucket);
            }
        } catch (e:ANEError) {
            trace(e.errorID, e.getStackTrace(), e.source);
        }

    }

    private function initMenu():void {
        btnRemoteConfig.x = btnBack.x = btnStorage.x = btnFirestore.x = btnAnalytics.x = (stage.stageWidth - 200) * 0.5;
        btnAnalytics.y = GAP;
        btnAnalytics.addEventListener(TouchEvent.TOUCH, onAnalyticsClick);
        menuContainer.addChild(btnAnalytics);

        btnFirestore.y = btnAnalytics.y + GAP;
        btnFirestore.addEventListener(TouchEvent.TOUCH, onFirestoreClick);
        menuContainer.addChild(btnFirestore);

        btnStorage.y = btnFirestore.y + GAP;
        btnStorage.addEventListener(TouchEvent.TOUCH, onStorageClick);
        menuContainer.addChild(btnStorage);

        btnRemoteConfig.y = btnStorage.y + GAP;
        btnRemoteConfig.addEventListener(TouchEvent.TOUCH, onRemoteConfigClick);
        menuContainer.addChild(btnRemoteConfig);

        btnBack.y = stage.stageHeight - 100;
        btnBack.addEventListener(TouchEvent.TOUCH, onBackClick);
        btnBack.visible = false;
        addChild(btnBack);

        addChild(menuContainer);
    }

    private function onAnalyticsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAnalytics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (!analyticsExample) {
                analyticsExample = new AnalyticsExample(stage.stageWidth);
                analyticsExample.x = stage.stageWidth;
                addChild(analyticsExample);
            }
            showMenu(false);
            showExample(analyticsExample);
            btnBack.visible = true;
        }
    }

    private function showMenu(value:Boolean):void {
        var tween:Tween = new Tween(menuContainer, 0.5, Transitions.EASE_OUT);
        tween.moveTo(value ? 0 : -stage.stageWidth, 0);
        Starling.juggler.add(tween);
    }

    private function onFirestoreClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnFirestore);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (!firestoreExample) {
                firestoreExample = new FirestoreExample(stage.stageWidth);
                firestoreExample.x = stage.stageWidth;
                addChild(firestoreExample);
            }
            showMenu(false);
            showExample(firestoreExample);
            btnBack.visible = true;
        }
    }

    private function onStorageClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnStorage);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (!storageExample) {
                storageExample = new StorageExample(stage.stageWidth);
                storageExample.x = stage.stageWidth;
                addChild(storageExample);
            }
            showMenu(false);
            showExample(storageExample);
            btnBack.visible = true;
        }
    }

    private function onRemoteConfigClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRemoteConfig);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (!remoteConfigExample) {
                remoteConfigExample = new RemoteConfigExample(stage.stageWidth);
                remoteConfigExample.x = stage.stageWidth;
                addChild(remoteConfigExample);
            }
            showMenu(false);
            showExample(remoteConfigExample);
            btnBack.visible = true;
        }
    }

    private function showExample(example: Sprite, value:Boolean = true):void {
        var tween:Tween = new Tween(example, 0.5, Transitions.EASE_OUT);
        tween.moveTo(value ? 0 : stage.stageWidth, 0);
        Starling.juggler.add(tween);
    }

    private function onBackClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBack);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(true);
            if (analyticsExample) showExample(analyticsExample, false);
            if (firestoreExample) showExample(firestoreExample, false);
            if (storageExample) showExample(storageExample, false);
            if (remoteConfigExample) showExample(remoteConfigExample, false);
            btnBack.visible = false;
        }
    }

    private function onExiting(event:Event):void {
        FirebaseANE.dispose();
        AnalyticsANE.dispose();
        FirestoreANE.dispose();
        RemoteConfigANE.dispose();
    }

}
}