package views.examples {
import com.tuarua.firebase.CloudLabelDetector;
import com.tuarua.firebase.CloudLabelError;
import com.tuarua.firebase.LabelDetector;
import com.tuarua.firebase.LabelError;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.vision.CloudLabel;
import com.tuarua.firebase.vision.Label;
import com.tuarua.firebase.vision.LabelDetectorOptions;
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

public class LabelExample extends Sprite implements IExample {
    [Embed(source="../../../assets/beach.jpg")]
    public static const labelImageBitmap:Class;

    private var bmpLabelImage:Bitmap = new labelImageBitmap() as Bitmap;

    private var textImageDisplay:Image;
    private var textContainer:Sprite = new Sprite();

    private var btnOnDevice:SimpleButton = new SimpleButton("Detect On Device");
    private var btnInCloud:SimpleButton = new SimpleButton("Detect In Cloud");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var vision:VisionANE;
    private var labelDetector:LabelDetector;
    private var cloudLabelDetector:CloudLabelDetector;
    public function LabelExample(stageWidth:int, vision:VisionANE) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    private function initMenu():void {
        btnOnDevice.x = btnInCloud.x = (stageWidth - 200) * 0.5;
        btnOnDevice.y = StarlingRoot.GAP;
        btnOnDevice.addEventListener(TouchEvent.TOUCH, onDeviceClick);
        addChild(btnOnDevice);

        btnInCloud.y = btnOnDevice.y + StarlingRoot.GAP;
        btnInCloud.addEventListener(TouchEvent.TOUCH, OnCloudClick);
        addChild(btnInCloud);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnInCloud.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        textImageDisplay = new Image(Texture.fromBitmap(bmpLabelImage));
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
        var options:LabelDetectorOptions = new LabelDetectorOptions(0.75);
        labelDetector = vision.labelDetector(options);
        cloudLabelDetector = vision.cloudLabelDetector();

        isInited = true;
    }

    private function onDeviceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnOnDevice);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            textContainer.visible = true;
            textImageDisplay.visible = true;
            var visionImage:VisionImage = new VisionImage(bmpLabelImage.bitmapData);

            labelDetector.detect(visionImage, function (labels:Vector.<Label>, error:LabelError):void {
                labelDetector.close();
                if (error) {
                    statusLabel.text = "Label error: " + error.errorID + " : " + error.message;
                    return;
                }
                statusLabel.text = "";
                var index:int = 0;
                for each (var label:Label in labels) {
                    statusLabel.text = statusLabel.text + label.label + " : " + Math.floor(label.confidence * 100) + "%\n";
                    index++;
                    if (index > 2) break;
                }
            });
        }
    }

    private function OnCloudClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnInCloud);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            textContainer.visible = true;
            textImageDisplay.visible = true;
            var visionImage:VisionImage = new VisionImage(bmpLabelImage.bitmapData);
            cloudLabelDetector.detect(visionImage, function (labels:Vector.<CloudLabel>, error:CloudLabelError):void {
                cloudLabelDetector.close();
                if (error) {
                    statusLabel.text = "Cloud Label error: " + error.errorID + " : " + error.message;
                    return;
                }
                statusLabel.text = "";
                var index:int = 0;
                for each (var label:CloudLabel in labels) {
                    statusLabel.text = statusLabel.text + label.label + " : " + Math.floor(label.confidence * 100) + "%\n";
                    index++;
                    if (index > 2) break;
                }
            });

        }
    }

}
}
