package views.examples {
import com.tuarua.firebase.CloudTextRecognizer;
import com.tuarua.firebase.TextRecognizer;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.vision.Text;
import com.tuarua.firebase.vision.TextElement;
import com.tuarua.firebase.vision.TextError;
import com.tuarua.firebase.vision.TextLine;
import com.tuarua.firebase.vision.VisionImage;
import com.tuarua.firebase.vision.TextBlock;

import flash.display.Bitmap;
import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;

import views.SimpleButton;

public class TextExample extends Sprite implements IExample {

    [Embed(source="../../../assets/walk-on-grass.jpg")]
    public static const textImageBitmap:Class;

    [Embed(source="../../../assets/do-not-feed-birds.jpg")]
    public static const textCloudImageBitmap:Class;

    private var bmpTextImage:Bitmap = new textImageBitmap() as Bitmap;
    private var bmpCloudTextImage:Bitmap = new textCloudImageBitmap() as Bitmap;

    private var textImageDisplay:Image;
    private var cloudTextImageDisplay:Image;
    private var textContainer:Sprite = new Sprite();
    private var overlayContainer:Sprite = new Sprite();

    private var btnOnDevice:SimpleButton = new SimpleButton("Detect On Device");
    private var btnInCloud:SimpleButton = new SimpleButton("Detect In Cloud");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var textRecognizer:TextRecognizer;
    private var cloudTextRecognizer:CloudTextRecognizer;
    private var vision:VisionANE;

    public function TextExample(stageWidth:int, vision:VisionANE) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;

        textRecognizer = vision.onDeviceTextRecognizer();
        cloudTextRecognizer = vision.cloudTextRecognizer();
        isInited = true;
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

        textImageDisplay = new Image(Texture.fromBitmap(bmpTextImage));
        textContainer.addChild(textImageDisplay);
        cloudTextImageDisplay = new Image(Texture.fromBitmap(bmpCloudTextImage));
        textContainer.addChild(cloudTextImageDisplay);
        textImageDisplay.visible = false;

        var newScale:Number = (stageWidth - 30) / textContainer.width;
        textContainer.scaleY = textContainer.scaleX = newScale;
        textContainer.visible = false;
        textContainer.x = (stageWidth - textContainer.width) * 0.5;
        textContainer.y = statusLabel.y + StarlingRoot.GAP;

        textContainer.addChild(overlayContainer);
        addChild(textContainer);
    }

    private function onDeviceClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnOnDevice);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            clearOverlay();
            textContainer.visible = true;
            textImageDisplay.visible = true;
            cloudTextImageDisplay.visible = false;
            var visionImage:VisionImage = new VisionImage(bmpTextImage.bitmapData);
            textRecognizer.process(visionImage, onProcessed);
        }
    }

    private function OnCloudClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnInCloud);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            clearOverlay();
            textContainer.visible = true;
            textImageDisplay.visible = false;
            cloudTextImageDisplay.visible = true;
            var visionImage:VisionImage = new VisionImage(bmpCloudTextImage.bitmapData);
            cloudTextRecognizer.process(visionImage, onProcessed);

        }
    }

    private function onProcessed(text:Text, error:TextError):void {
        if (error) {
            statusLabel.text = "Text error: " + error.errorID + " : " + error.message;
            return;
        }
        trace(text.text);
        for each (var block:TextBlock in text.blocks) {
            for each (var line:TextLine in block.lines) {
                var frame:Rectangle;
                for each (var element:TextElement in line.elements) {
                    frame = element.frame;
                    var hl:TextElementHighlight = new TextElementHighlight(frame, element.text);
                    overlayContainer.addChild(hl);
                }
            }
        }
    }

    private function clearOverlay():void {
        while (overlayContainer.numChildren > 0) {
            overlayContainer.removeChildAt(0);
        }
    }

}
}