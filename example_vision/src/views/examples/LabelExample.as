package views.examples {
import com.tuarua.firebase.Vision;
import com.tuarua.firebase.ml.vision.common.VisionImage;
import com.tuarua.firebase.ml.vision.label.CloudImageError;
import com.tuarua.firebase.ml.vision.label.CloudImageLabeler;
import com.tuarua.firebase.ml.vision.label.VisionImageLabel;

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

    private var btnInCloud:SimpleButton = new SimpleButton("Detect In Cloud");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var vision:Vision;
    private var cloudImageLabeler:CloudImageLabeler;

    public function LabelExample(stageWidth:int, vision:Vision) {
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
        cloudImageLabeler = vision.cloudLabelDetector();

        isInited = true;
    }

    private function OnCloudClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnInCloud);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            textContainer.visible = true;
            textImageDisplay.visible = true;
            var visionImage:VisionImage = new VisionImage(bmpLabelImage.bitmapData);
            cloudImageLabeler.process(visionImage, function (labels:Vector.<VisionImageLabel>, error:CloudImageError):void {
                cloudImageLabeler.close();
                if (error) {
                    statusLabel.text = "Cloud Label error: " + error.errorID + " : " + error.message;
                    return;
                }
                statusLabel.text = "";
                var index:int = 0;
                for each (var label:VisionImageLabel in labels) {
                    statusLabel.text = statusLabel.text + label.text + " : " + Math.floor(label.confidence * 100) + "%\n";
                    index++;
                    if (index > 2) break;
                }
            });

        }
    }

}
}
