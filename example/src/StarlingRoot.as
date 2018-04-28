package {
import com.tuarua.FirebaseANE;
import com.tuarua.firebase.AnalyticsANE;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.FirestoreANE;
import com.tuarua.fre.ANEError;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

import views.SimpleButton;
import views.examples.Analytics;
import views.examples.Firestore;
import views.examples.Storage;

// https://dandar3.github.io/android/google-services-json-to-xml.html

public class StarlingRoot extends Sprite {
    private var btnAnalytics:SimpleButton = new SimpleButton("Analytics");
    private var btnFirestore:SimpleButton = new SimpleButton("Firestore");
    private var btnStorage:SimpleButton = new SimpleButton("Storage");

    private var btnBack:SimpleButton = new SimpleButton("Back");

    public static const GAP:int = 60;
    private var analyticsExample:Analytics;
    private var firestoreExample:Firestore;
    private var storageExample:Storage;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        initMenu();

        FirebaseANE.init();

        var fo:FirebaseOptions = FirebaseANE.options;
        if (fo) {
            trace("apiKey", fo.apiKey);
            trace("googleAppId", fo.googleAppId);
            trace("storageBucket", fo.storageBucket);
        }

    }

    private function initMenu():void {
        btnBack.x = btnStorage.x = btnFirestore.x = btnAnalytics.x = (stage.stageWidth - 200) * 0.5;
        btnAnalytics.y = GAP;
        btnAnalytics.addEventListener(TouchEvent.TOUCH, onAnalyticsClick);
        addChild(btnAnalytics);

        btnFirestore.y = btnAnalytics.y + GAP;
        btnFirestore.addEventListener(TouchEvent.TOUCH, onFirestoreClick);
        addChild(btnFirestore);

        btnStorage.y = btnFirestore.y + GAP;
        btnStorage.addEventListener(TouchEvent.TOUCH, onStorageClick);
        addChild(btnStorage);

        btnBack.y = stage.stageHeight - 100;
        btnBack.addEventListener(TouchEvent.TOUCH, onBackClick);
        btnBack.visible = false;
        addChild(btnBack);
    }

    private function onAnalyticsClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnAnalytics);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (!analyticsExample) {
                analyticsExample = new Analytics(stage.stageWidth);
                addChild(analyticsExample);
            }
            showMenu(false);
            analyticsExample.visible = true;
            btnBack.visible = true;
        }
    }

    private function showMenu(value:Boolean):void {
        btnStorage.visible = btnFirestore.visible = btnAnalytics.visible = value;
    }

    private function onFirestoreClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnFirestore);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            if (!firestoreExample) {
                firestoreExample = new Firestore(stage.stageWidth);
                addChild(firestoreExample);
            }
            showMenu(false);
            firestoreExample.visible = true;
            btnBack.visible = true;
        }
    }

    private function onStorageClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnStorage);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            storageExample
            if (!storageExample) {
                storageExample = new Storage(stage.stageWidth);
                addChild(storageExample);
            }
            showMenu(false);
            storageExample.visible = true;
            btnBack.visible = true;
        }
    }

    private function onBackClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBack);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(true);
            if (analyticsExample) analyticsExample.visible = false;
            if (firestoreExample) firestoreExample.visible = false;
            if (storageExample) storageExample.visible = false;
            btnBack.visible = false;
        }
    }

    private function onExiting(event:Event):void {
        FirebaseANE.dispose();
        AnalyticsANE.dispose();
        FirestoreANE.dispose();
    }

}
}