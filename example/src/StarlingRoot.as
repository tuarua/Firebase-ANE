package {
import com.tuarua.Firebase;
import com.tuarua.firebase.Analytics;
import com.tuarua.firebase.Auth;
import com.tuarua.firebase.Crashlytics;

import com.tuarua.firebase.DynamicLinks;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.Firestore;
import com.tuarua.firebase.Messaging;
import com.tuarua.firebase.Performance;
import com.tuarua.firebase.RemoteConfig;
import com.tuarua.firebase.Storage;
import com.tuarua.fre.ANEError;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.animation.Transitions;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import views.SimpleButton;
import views.examples.*;


public class StarlingRoot extends Sprite {
    private var btnAnalytics:SimpleButton = new SimpleButton("Analytics");
    private var btnFirestore:SimpleButton = new SimpleButton("Firestore");
    private var btnStorage:SimpleButton = new SimpleButton("Storage");
    private var btnRemoteConfig:SimpleButton = new SimpleButton("Remote Config");
    private var btnAuth:SimpleButton = new SimpleButton("Auth");
    private var btnPerformance:SimpleButton = new SimpleButton("Performance");
    private var btnMessaging:SimpleButton = new SimpleButton("Messaging");
    private var btnDynamicLinks:SimpleButton = new SimpleButton("Dynamic Links");
    private var btnCrashlytics:SimpleButton = new SimpleButton("Crashlytics");

    private var btnBack:SimpleButton = new SimpleButton("Back");
    private var menuContainer:Sprite = new Sprite();

    public static const GAP:int = 60;
    private var analyticsExample:AnalyticsExample;
    private var firestoreExample:FirestoreExample;
    private var storageExample:StorageExample;
    private var remoteConfigExample:RemoteConfigExample;
    private var authExample:AuthExample;
    private var performanceExample:PerformanceExample;
    private var messagingExample:MessagingExample;
    private var dynamicLinksExample:DynamicLinksExample;
    private var crashlyticsExample:CrashlyticsExample;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        try {
            Firebase.init();
            if(!Firebase.isGooglePlayServicesAvailable) {
                trace("Google Play Services Not Available");
                return;
            }
            var fo:FirebaseOptions = Firebase.options;
            if (fo) {
                trace("apiKey", fo.apiKey);
                trace("googleAppId", fo.googleAppId);
                trace("storageBucket", fo.storageBucket);
            }
        } catch (e:ANEError) {
            trace(e.errorID, e.message, e.getStackTrace(), e.source);
        }
        initMenu();


        analyticsExample = new AnalyticsExample(stage.stageWidth);
        analyticsExample.x = stage.stageWidth;
        addChild(analyticsExample);

        firestoreExample = new FirestoreExample(stage.stageWidth);
        firestoreExample.x = stage.stageWidth;
        addChild(firestoreExample);

        remoteConfigExample = new RemoteConfigExample(stage.stageWidth);
        remoteConfigExample.x = stage.stageWidth;
        addChild(remoteConfigExample);

        storageExample = new StorageExample(stage.stageWidth);
        storageExample.x = stage.stageWidth;
        addChild(storageExample);

        authExample = new AuthExample(stage.stageWidth);
        authExample.x = stage.stageWidth;
        addChild(authExample);

        performanceExample = new PerformanceExample(stage.stageWidth);
        performanceExample.x = stage.stageWidth;
        addChild(performanceExample);

        messagingExample = new MessagingExample(stage.stageWidth);
        messagingExample.x = stage.stageWidth;
        addChild(messagingExample);

        dynamicLinksExample = new DynamicLinksExample(stage.stageWidth);
        dynamicLinksExample.x = stage.stageWidth;
        addChild(dynamicLinksExample);

        crashlyticsExample = new CrashlyticsExample(stage.stageWidth);
        crashlyticsExample.x = stage.stageWidth;
        addChild(crashlyticsExample);


    }

    private function initMenu():void {
        btnCrashlytics.x = btnDynamicLinks.x = btnMessaging.x = btnPerformance.x = btnAuth.x = btnRemoteConfig.x = btnBack.x = btnStorage.x =
                btnFirestore.x = btnAnalytics.x = (stage.stageWidth - 200) * 0.5;
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

        btnAuth.y = btnRemoteConfig.y + GAP;
        btnAuth.addEventListener(TouchEvent.TOUCH, onAuthClick);
        menuContainer.addChild(btnAuth);

        btnPerformance.y = btnAuth.y + GAP;
        btnPerformance.addEventListener(TouchEvent.TOUCH, onPerformanceClick);
        menuContainer.addChild(btnPerformance);

        btnMessaging.y = btnPerformance.y + GAP;
        btnMessaging.addEventListener(TouchEvent.TOUCH, onMessagingClick);
        menuContainer.addChild(btnMessaging);

        btnDynamicLinks.y = btnMessaging.y + GAP;
        btnDynamicLinks.addEventListener(TouchEvent.TOUCH, onDynamicLinksClick);
        menuContainer.addChild(btnDynamicLinks);

        btnCrashlytics.y = btnDynamicLinks.y + GAP;
        btnCrashlytics.addEventListener(TouchEvent.TOUCH, onCrashlyticsClick);
        menuContainer.addChild(btnCrashlytics);

        btnBack.y = stage.stageHeight - 100;
        btnBack.addEventListener(TouchEvent.TOUCH, onBackClick);
        btnBack.visible = false;

        addChild(menuContainer);

        addChild(btnBack);
    }

    private function onAnalyticsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAnalytics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
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
            showMenu(false);
            showExample(firestoreExample);
            btnBack.visible = true;
        }
    }

    private function onStorageClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnStorage);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(storageExample);
            btnBack.visible = true;
        }
    }

    private function onRemoteConfigClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRemoteConfig);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(remoteConfigExample);
            btnBack.visible = true;
        }
    }

    private function onAuthClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAuth);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(authExample);
            btnBack.visible = true;
        }
    }

    private function onPerformanceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPerformance);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(performanceExample);
            btnBack.visible = true;
        }
    }

    private function onMessagingClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnMessaging);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(messagingExample);
            btnBack.visible = true;
        }
    }

    private function onDynamicLinksClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDynamicLinks);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(dynamicLinksExample);
            btnBack.visible = true;
        }
    }

    private function onCrashlyticsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCrashlytics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(crashlyticsExample);
            btnBack.visible = true;
        }
    }

    private function showExample(example:IExample, value:Boolean = true):void {
        var tween:Tween = new Tween(example, 0.5, Transitions.EASE_OUT);
        tween.moveTo(value ? 0 : stage.stageWidth, 0);
        tween.onComplete = function ():void {
            if (value) {
                example.initANE();
            }
        };
        Starling.juggler.add(tween);
    }

    private function onBackClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBack);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(true);
            showExample(analyticsExample, false);
            showExample(firestoreExample, false);
            showExample(storageExample, false);
            showExample(remoteConfigExample, false);
            showExample(authExample, false);
            showExample(performanceExample, false);
            showExample(messagingExample, false);
            showExample(dynamicLinksExample, false);
            showExample(crashlyticsExample, false);
            btnBack.visible = false;
        }
    }

    private function onExiting(event:Event):void {
        Firebase.dispose();
        Analytics.dispose();
        Firestore.dispose();
        Storage.dispose();
        RemoteConfig.dispose();
        Auth.dispose();
        Performance.dispose();
        Messaging.dispose();
        DynamicLinks.dispose();
        Crashlytics.dispose();
    }

}
}