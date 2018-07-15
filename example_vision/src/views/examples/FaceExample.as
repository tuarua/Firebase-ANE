package views.examples {
import com.tuarua.firebase.FaceDetector;
import com.tuarua.firebase.FaceError;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.vision.Face;
import com.tuarua.firebase.vision.FaceDetectorClassification;
import com.tuarua.firebase.vision.FaceDetectorLandmark;
import com.tuarua.firebase.vision.FaceDetectorMode;
import com.tuarua.firebase.vision.FaceDetectorOptions;
import com.tuarua.firebase.vision.FaceLandmark;
import com.tuarua.firebase.vision.FaceLandmarkType;
import com.tuarua.firebase.vision.VisionImage;

import flash.display.Bitmap;

import roipeker.display.MeshRoundRect;

import starling.display.Canvas;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.FragmentFilter;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

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
    private var faceContainer:Sprite = new Sprite();

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

        faceContainer.visible = false;
        faceContainer.addChild(faceDisplay);

        if (faceContainer.width > (stageWidth - 30)) {
            var newScale:Number = (stageWidth - 30) / faceContainer.width;
            faceContainer.scaleY = faceContainer.scaleX = newScale;
        }

        faceContainer.x = (stageWidth - faceContainer.width) * 0.5;
        faceContainer.y = statusLabel.y + StarlingRoot.GAP;

        addChild(faceContainer);
    }

    private function onFaceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDetectFace);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            faceContainer.visible = true;
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

                            var box:MeshRoundRect = new MeshRoundRect();
                            box.setup(face.frame.width, face.frame.height, 20);
                            box.color = Color.GREEN;
                            box.x = face.frame.x;
                            box.y = face.frame.y;
                            box.alpha = 0.3;

                            trace("face.landmarks.length", face.landmarks.length);

                            var canvas:Canvas = new Canvas();

                            var leftEye:FaceLandmark = face.landmark(FaceLandmarkType.leftEye);
                            var rightEye:FaceLandmark = face.landmark(FaceLandmarkType.rightEye);
                            var leftEar:FaceLandmark = face.landmark(FaceLandmarkType.leftEar);
                            var rightEar:FaceLandmark = face.landmark(FaceLandmarkType.rightEar);
                            var leftCheek:FaceLandmark = face.landmark(FaceLandmarkType.leftCheek);
                            var rightCheek:FaceLandmark = face.landmark(FaceLandmarkType.rightCheek);
                            var noseBase:FaceLandmark = face.landmark(FaceLandmarkType.noseBase);
                            var mouthLeft:FaceLandmark = face.landmark(FaceLandmarkType.mouthLeft);
                            var mouthBottom:FaceLandmark = face.landmark(FaceLandmarkType.mouthBottom);
                            var mouthRight:FaceLandmark = face.landmark(FaceLandmarkType.mouthRight);

                            canvas.beginFill(Color.AQUA);
                            if (leftEye) canvas.drawCircle(leftEye.position.x, leftEye.position.y, 5);
                            if (rightEye) canvas.drawCircle(rightEye.position.x, rightEye.position.y, 5);
                            canvas.endFill();

                            canvas.beginFill(Color.PURPLE);
                            if (leftEar) canvas.drawCircle(leftEar.position.x, leftEar.position.y, 5);
                            if (rightEar) canvas.drawCircle(rightEar.position.x, rightEar.position.y, 5);
                            canvas.endFill();

                            canvas.beginFill(0xFFA500);
                            if (leftCheek) canvas.drawCircle(leftCheek.position.x, leftCheek.position.y, 5);
                            if (rightCheek) canvas.drawCircle(rightCheek.position.x, rightCheek.position.y, 5);
                            canvas.endFill();

                            canvas.beginFill(Color.YELLOW);
                            if (noseBase) canvas.drawCircle(noseBase.position.x, noseBase.position.y, 3);
                            canvas.endFill();

                            canvas.beginFill(Color.RED);
                            if (mouthLeft) canvas.drawCircle(mouthLeft.position.x, mouthLeft.position.y, 3);
                            if (mouthBottom) canvas.drawCircle(mouthBottom.position.x, mouthBottom.position.y, 3);
                            if (mouthRight) canvas.drawCircle(mouthRight.position.x, mouthRight.position.y, 3);
                            canvas.endFill();

                            var filter:FragmentFilter = new FragmentFilter();
                            filter.resolution = 5.0;
                            canvas.filter = filter;
                            canvas.filter.cache();

                            faceContainer.addChild(box);
                            faceContainer.addChild(canvas);
                        }
                    });
        }
    }
}
}
