package views.examples {
import com.tuarua.firebase.Vision;
import com.tuarua.firebase.ml.vision.cloud.CloudDetectorOptions;
import com.tuarua.firebase.ml.vision.cloud.CloudModelType;
import com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmark;
import com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmarkDetector;
import com.tuarua.firebase.ml.vision.cloud.landmark.LandmarkError;
import com.tuarua.firebase.ml.vision.common.VisionImage;

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

public class LandmarkExample extends Sprite implements IExample {
    [Embed(source="../../../assets/bruges.jpg")]
    public static const brugesImageBitmap:Class;

    private var bmpLandmarkImage:Bitmap = new brugesImageBitmap() as Bitmap;

    private var btnInCloud:SimpleButton = new SimpleButton("Detect Landmark");

    private var textImageDisplay:Image;
    private var textContainer:Sprite = new Sprite();

    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var vision:Vision;
    private var cloudLandmarkDetector:CloudLandmarkDetector;

    public function LandmarkExample(stageWidth:int, vision:Vision) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    private function initMenu():void {
        btnInCloud.x = (stageWidth - 200) * 0.5;

        btnInCloud.y = StarlingRoot.GAP;
        btnInCloud.addEventListener(TouchEvent.TOUCH, OnCloudClick);
        addChild(btnInCloud);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnInCloud.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        textImageDisplay = new Image(Texture.fromBitmap(bmpLandmarkImage));
        textContainer.visible = false;
        textContainer.addChild(textImageDisplay);

        var newScale:Number = (stageWidth - 30) / textContainer.width;
        textContainer.scaleY = textContainer.scaleX = newScale;

        textContainer.x = (stageWidth - textContainer.width) * 0.5;
        textContainer.y = statusLabel.y + StarlingRoot.GAP;

        addChild(textContainer);
    }

    public function initANE():void {
        if (isInited) return;
        var options:CloudDetectorOptions = new CloudDetectorOptions();
        options.modelType = CloudModelType.latest;
        options.maxResults = 20;

        cloudLandmarkDetector = vision.cloudLandmarkDetector(options);

        isInited = true;
    }

    private function OnCloudClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnInCloud);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var visionImage:VisionImage = new VisionImage(bmpLandmarkImage.bitmapData);
            textContainer.visible = true;
            textImageDisplay.visible = true;
            cloudLandmarkDetector.detect(visionImage,
                    function (landmarks:Vector.<CloudLandmark>, error:LandmarkError):void {
                        cloudLandmarkDetector.close();
                        if (error) {
                            statusLabel.text = "Landmark error: " + error.errorID + " : " + error.message;
                            return;
                        }
                        statusLabel.text = "";
                        var index:int = 0;
                        for each (var landmark:CloudLandmark in landmarks) {
                            statusLabel.text = statusLabel.text + landmark.landmark + " : "
                                    + Math.floor(landmark.confidence * 100) + "%\n";
                            index++;
                            if (index > 2) break;
                        }
                    });

        }
    }

}
}
