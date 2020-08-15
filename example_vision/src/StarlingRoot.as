package {
import com.tuarua.Firebase;
import com.tuarua.firebase.FirebaseOptions;
import com.tuarua.firebase.Vision;
import com.tuarua.firebase.ml.custom.ModelInterpreter;
import com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmarkDetector;
import com.tuarua.firebase.ml.vision.label.CloudImageLabeler;
import com.tuarua.firebase.ml.vision.text.CloudTextRecognizer;
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
    private var btnText:SimpleButton = new SimpleButton("Text");
    private var btnLabel:SimpleButton = new SimpleButton("Label");
    private var btnLandmark:SimpleButton = new SimpleButton("Landmark");
    private var btnTensorFlow:SimpleButton = new SimpleButton("Tensor Flow");

    private var btnBack:SimpleButton = new SimpleButton("Back");
    private var menuContainer:Sprite = new Sprite();

    public static const GAP:int = 60;
    private var textExample:TextExample;
    private var labelExample:LabelExample;
    private var landmarkExample:LandmarkExample;
    private var tensorFlowExample:TensorFlowExample;

    private var vision:Vision;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        try {
            Firebase.init();
            if (!Firebase.isGooglePlayServicesAvailable) {
                trace("Google Play Services Not Available");
                return;
            }
            var fo:FirebaseOptions = Firebase.options;
            if (fo) {
                trace("apiKey", fo.apiKey);
                trace("googleAppId", fo.googleAppId);
                trace("storageBucket", fo.storageBucket);
            }

            vision = Vision.vision;
            initMenu();
        } catch (e:ANEError) {
            trace(e.errorID, e.message, e.getStackTrace(), e.source);
        }
    }

    private function initMenu():void {
        textExample = new TextExample(stage.stageWidth, vision);
        textExample.x = stage.stageWidth;
        addChild(textExample);

        labelExample = new LabelExample(stage.stageWidth, vision);
        labelExample.x = stage.stageWidth;
        addChild(labelExample);

        landmarkExample = new LandmarkExample(stage.stageWidth, vision);
        landmarkExample.x = stage.stageWidth;
        addChild(landmarkExample);

        tensorFlowExample = new TensorFlowExample(stage.stageWidth);
        tensorFlowExample.x = stage.stageWidth;
        addChild(tensorFlowExample);

        btnTensorFlow.x = btnLandmark.x =  btnLabel.x = btnText.x = btnBack.x = (stage.stageWidth - 200) * 0.5;

        btnText.y = GAP;
        btnText.addEventListener(TouchEvent.TOUCH, onTextClick);
        menuContainer.addChild(btnText);

        btnLabel.y = btnText.y + GAP;
        btnLabel.addEventListener(TouchEvent.TOUCH, onLabelClick);
        menuContainer.addChild(btnLabel);

        btnLandmark.y = btnLabel.y + GAP;
        btnLandmark.addEventListener(TouchEvent.TOUCH, onLandmarkClick);
        menuContainer.addChild(btnLandmark);


        btnTensorFlow.y = btnLandmark.y + GAP;
        btnTensorFlow.addEventListener(TouchEvent.TOUCH, onTensorFlowClick);
        menuContainer.addChild(btnTensorFlow);

        btnBack.y = stage.stageHeight - 100;
        btnBack.addEventListener(TouchEvent.TOUCH, onBackClick);
        btnBack.visible = false;

        addChild(menuContainer);
        addChild(btnBack);
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

    private function onTensorFlowClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnTensorFlow);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            showMenu(false);
            showExample(tensorFlowExample);
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
            showExample(textExample, false);
            showExample(labelExample, false);
            showExample(landmarkExample, false);
            showExample(tensorFlowExample, false);
            btnBack.visible = false;
        }
    }

    private static function onExiting(event:Event):void {
        Firebase.dispose();
        CloudTextRecognizer.dispose();
        CloudImageLabeler.dispose();
        CloudLandmarkDetector.dispose();
        Vision.dispose();
        ModelInterpreter.dispose();
    }

}
}