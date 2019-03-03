package {
import com.tuarua.FirebaseANE;
import com.tuarua.firebase.BarcodeDetector;
import com.tuarua.firebase.CloudLabelDetector;
import com.tuarua.firebase.CloudLandmarkDetector;
import com.tuarua.firebase.CloudTextRecognizer;
import com.tuarua.firebase.FaceDetector;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.LabelDetector;
import com.tuarua.firebase.NaturalLanguageANE;
import com.tuarua.firebase.TextRecognizer;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.permissions.PermissionEvent;
import com.tuarua.firebase.permissions.PermissionStatus;
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
    private var btnLabel:SimpleButton = new SimpleButton("Label");
    private var btnLandmark:SimpleButton = new SimpleButton("Landmark");
    private var btnLanguage:SimpleButton = new SimpleButton("Natural Language");

    private var btnBack:SimpleButton = new SimpleButton("Back");
    private var menuContainer:Sprite = new Sprite();

    public static const GAP:int = 60;
    private var barcodeExample:BarcodeExample;
    private var faceExample:FaceExample;
    private var textExample:TextExample;
    private var labelExample:LabelExample;
    private var landmarkExample:LandmarkExample;
    private var languageExample:NaturalLanguageExample;

    private var vision:VisionANE;
    private var naturalLanguage:NaturalLanguageANE;

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

            naturalLanguage = NaturalLanguageANE.naturalLanguage;

            vision = VisionANE.vision;
            vision.cameraOverlay.contentScaleFactor = Starling.contentScaleFactor;
            vision.addEventListener(PermissionEvent.STATUS_CHANGED, onPermissionsStatus);
            vision.requestPermissions();
        } catch (e:ANEError) {
            trace(e.errorID, e.message, e.getStackTrace(), e.source);
        }
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

        labelExample = new LabelExample(stage.stageWidth, vision);
        labelExample.x = stage.stageWidth;
        addChild(labelExample);

        landmarkExample = new LandmarkExample(stage.stageWidth, vision);
        landmarkExample.x = stage.stageWidth;
        addChild(landmarkExample);

        languageExample = new NaturalLanguageExample(stage.stageWidth, naturalLanguage);
        languageExample.x = stage.stageWidth;
        addChild(languageExample);

        btnLanguage.x = btnLandmark.x =  btnLabel.x = btnText.x = btnFace.x = btnBack.x = btnBarcode.x = (stage.stageWidth - 200) * 0.5;
        btnBarcode.y = GAP;
        btnBarcode.addEventListener(TouchEvent.TOUCH, onBarcodeClick);
        menuContainer.addChild(btnBarcode);

        btnFace.y = btnBarcode.y + GAP;
        btnFace.addEventListener(TouchEvent.TOUCH, onFaceClick);
        menuContainer.addChild(btnFace);

        btnText.y = btnFace.y + GAP;
        btnText.addEventListener(TouchEvent.TOUCH, onTextClick);
        menuContainer.addChild(btnText);

        btnLabel.y = btnText.y + GAP;
        btnLabel.addEventListener(TouchEvent.TOUCH, onLabelClick);
        menuContainer.addChild(btnLabel);

        btnLandmark.y = btnLabel.y + GAP;
        btnLandmark.addEventListener(TouchEvent.TOUCH, onLandmarkClick);
        menuContainer.addChild(btnLandmark);

        btnLanguage.y = btnLandmark.y + GAP;
        btnLanguage.addEventListener(TouchEvent.TOUCH, onLanguageClick);
        menuContainer.addChild(btnLanguage);

        btnBack.y = stage.stageHeight - 100;
        btnBack.addEventListener(TouchEvent.TOUCH, onBackClick);
        btnBack.visible = false;

        addChild(menuContainer);

        addChild(btnBack);
    }

    private function onLanguageClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLanguage);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(languageExample);
            btnBack.visible = true;
        }
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

    private function onLabelClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLabel);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(labelExample);
            btnBack.visible = true;
        }
    }

    private function onLandmarkClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLandmark);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(landmarkExample);
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
            showExample(labelExample, false);
            showExample(landmarkExample, false);
            showExample(languageExample, false);
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
        TextRecognizer.dispose();
        CloudTextRecognizer.dispose();
        LabelDetector.dispose();
        CloudLabelDetector.dispose();
        CloudLandmarkDetector.dispose();
        VisionANE.dispose();
        NaturalLanguageANE.dispose();
    }

}
}