package views.examples {
import com.tuarua.firebase.FaceDetector;
import com.tuarua.firebase.FaceError;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.vision.Face;
import com.tuarua.firebase.vision.FaceDetectorClassification;
import com.tuarua.firebase.vision.FaceDetectorLandmark;
import com.tuarua.firebase.vision.FaceDetectorMode;
import com.tuarua.firebase.vision.FaceDetectorOptions;
import com.tuarua.firebase.vision.VisionImage;

import flash.display.Bitmap;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;

import views.SimpleButton;

public class FaceExample extends Sprite implements IExample {

    [Embed(source="../../../assets/grace_hopper.jpg")]
    public static const faceBitmap:Class;

    private var btnDetectFace:SimpleButton = new SimpleButton("Detect Face");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var faceDetector:FaceDetector;
    private var isInited:Boolean;

    private var bmpFace:Bitmap = new faceBitmap() as Bitmap;

    private var vision:VisionANE;

    public function FaceExample(stageWidth:int, vision:VisionANE) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        initMenu();


    }

    public function initANE():void {
        if (isInited) return;
        var options:FaceDetectorOptions = new FaceDetectorOptions();
        options.classificationType = FaceDetectorClassification.all;
        options.landmarkType = FaceDetectorLandmark.all;
        options.modeType = FaceDetectorMode.accurate;
        faceDetector = vision.faceDetector(options);
        isInited = true;

    }

    private function initMenu():void {
        btnDetectFace.x = (stageWidth - 200) * 0.5;
        btnDetectFace.y = StarlingRoot.GAP;
        btnDetectFace.addEventListener(TouchEvent.TOUCH, onFaceClick);
        addChild(btnDetectFace);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnDetectFace.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        var faceDisplay:Image = new Image(Texture.fromBitmap(bmpFace));
        faceDisplay.x = (stageWidth - faceDisplay.width) * 0.5;
        faceDisplay.y = statusLabel.y + (StarlingRoot.GAP * 1.25);
        addChild(faceDisplay);

    }

    private function onFaceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDetectFace);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var visionImage:VisionImage = new VisionImage(bmpFace.bitmapData);
            faceDetector.detect(visionImage,
                    function (features:Vector.<Face>, error:FaceError):void {
                        statusLabel.text = "";
                        if (error) {
                            statusLabel.text = "Face error: " + error.errorID + " : " + error.message;
                            return;
                        }
                        for each (var face:Face in features) {
                            trace(face.frame.toString());
                            //statusLabel.text += "frame: "+ face.frame.toString() + "\n";
                            //statusLabel.text += "smilingProbability: "+ face.smilingProbability + "\n";
                        }
                    });
        }
    }
}
}
