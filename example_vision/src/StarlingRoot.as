package {
import com.tuarua.FirebaseANE;
import com.tuarua.firebase.BarcodeDetector;
import com.tuarua.firebase.FaceDetector;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.TextDetector;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.permissions.PermissionEvent;
import com.tuarua.firebase.permissions.PermissionStatus;
import com.tuarua.firebase.vision.Barcode;
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
    private var btnBarcode:SimpleButton = new SimpleButton("Barcode");
    private var btnFace:SimpleButton = new SimpleButton("Face");
    private var btnText:SimpleButton = new SimpleButton("Text");

    private var btnBack:SimpleButton = new SimpleButton("Back");
    private var menuContainer:Sprite = new Sprite();

    public static const GAP:int = 60;
    private var barcodeExample:BarcodeExample;
    private var faceExample:FaceExample;
    private var textExample:TextExample;

    private var vision:VisionANE;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        try {
            FirebaseANE.init();
            if (!FirebaseANE.isGooglePlayServicesAvailable) {
                trace("Google Play Services Not Available");
                return;
            }
            var fo:FirebaseOptions = FirebaseANE.options;
            if (fo) {
                trace("apiKey", fo.apiKey);
                trace("googleAppId", fo.googleAppId);
                trace("storageBucket", fo.storageBucket);
            }

            vision = VisionANE.vision;
        } catch (e:ANEError) {
            trace(e.errorID, e.message, e.getStackTrace(), e.source);
        }

        vision.addEventListener(PermissionEvent.STATUS_CHANGED, onPermissionsStatus);
        vision.requestPermissions();

    }

    private function initMenu():void {
        barcodeExample = new BarcodeExample(stage.stageWidth, stage.stageHeight, vision);
        barcodeExample.x = stage.stageWidth;
        addChild(barcodeExample);

        faceExample = new FaceExample(stage.stageWidth, vision);
        faceExample.x = stage.stageWidth;
        addChild(faceExample);

        textExample = new TextExample(stage.stageWidth, vision);
        textExample.x = stage.stageWidth;
        addChild(textExample);

        btnText.x = btnFace.x = btnBack.x = btnBarcode.x = (stage.stageWidth - 200) * 0.5;
        btnBarcode.y = GAP;
        btnBarcode.addEventListener(TouchEvent.TOUCH, onBarcodeClick);
        menuContainer.addChild(btnBarcode);

        btnFace.y = btnBarcode.y + GAP;
        btnFace.addEventListener(TouchEvent.TOUCH, onFaceClick);
        menuContainer.addChild(btnFace);

        btnText.y = btnFace.y + GAP;
        btnText.addEventListener(TouchEvent.TOUCH, onTextClick);
        menuContainer.addChild(btnText);

        btnBack.y = stage.stageHeight - 100;
        btnBack.addEventListener(TouchEvent.TOUCH, onBackClick);
        btnBack.visible = false;

        addChild(menuContainer);

        addChild(btnBack);
    }

    private function onBarcodeClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBarcode);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(barcodeExample);
            btnBack.visible = true;
        }
    }

    private function onFaceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnFace);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(faceExample);
            btnBack.visible = true;
        }
    }

    private function onTextClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnText);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(textExample);
            btnBack.visible = true;
        }
    }

    private function showMenu(value:Boolean):void {
        var tween:Tween = new Tween(menuContainer, 0.5, Transitions.EASE_OUT);
        tween.moveTo(value ? 0 : -stage.stageWidth, 0);
        Starling.juggler.add(tween);
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
            showExample(barcodeExample, false);
            showExample(faceExample, false);
            showExample(textExample, false);

            btnBack.visible = false;
        }
    }

    private function onPermissionsStatus(event:PermissionEvent):void {
        if (event.status == PermissionStatus.ALLOWED) {
            initMenu();
        } else if (event.status == PermissionStatus.NOT_DETERMINED) {
        } else {
            trace("Allow camera for Vision usage");
        }
    }

    private static function onExiting(event:Event):void {
        FirebaseANE.dispose();
        BarcodeDetector.dispose();
        FaceDetector.dispose();
        TextDetector.dispose();
        VisionANE.dispose();
    }

}
}