package views.examples {
import com.tuarua.firebase.Vision;
import com.tuarua.firebase.ml.vision.common.VisionImage;
import com.tuarua.firebase.ml.vision.document.CloudDocumentRecognizerOptions;
import com.tuarua.firebase.ml.vision.document.CloudDocumentTextRecognizer;
import com.tuarua.firebase.ml.vision.document.DocumentText;
import com.tuarua.firebase.ml.vision.document.DocumentTextBlock;
import com.tuarua.firebase.ml.vision.text.CloudText;
import com.tuarua.firebase.ml.vision.text.CloudTextBlock;
import com.tuarua.firebase.ml.vision.text.CloudTextElement;
import com.tuarua.firebase.ml.vision.text.CloudTextError;
import com.tuarua.firebase.ml.vision.text.CloudTextLine;
import com.tuarua.firebase.ml.vision.text.CloudTextRecognizer;

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

    [Embed(source="../../../assets/dracula_p361.jpg")]
    public static const textDocumentCloudImageBitmap:Class;

    private var bmpTextImage:Bitmap = new textImageBitmap() as Bitmap;
    private var bmpCloudTextImage:Bitmap = new textCloudImageBitmap() as Bitmap;
    private var bmpCloudDocumentImage:Bitmap = new textDocumentCloudImageBitmap() as Bitmap;

    private var textImageDisplay:Image;
    private var cloudTextImageDisplay:Image;
    private var cloudDocumentImageDisplay:Image;
    private var textContainer:Sprite = new Sprite();
    private var overlayContainer:Sprite = new Sprite();

    private var btnInCloud:SimpleButton = new SimpleButton("Detect In Cloud");
    private var btnDocumentInCloud:SimpleButton = new SimpleButton("Detect Document In Cloud");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var cloudTextRecognizer:CloudTextRecognizer;
    private var cloudDocumentRecognizer:CloudDocumentTextRecognizer;
    private var vision:Vision;

    public function TextExample(stageWidth:int, vision:Vision) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;

        cloudTextRecognizer = vision.cloudTextRecognizer();
        var documentOptions:CloudDocumentRecognizerOptions = new CloudDocumentRecognizerOptions();
        documentOptions.languageHints = new <String>["en"];
        cloudDocumentRecognizer = vision.cloudDocumentTextRecognizer(documentOptions);
        isInited = true;
    }

    private function initMenu():void {
        btnDocumentInCloud.x = btnInCloud.x = (stageWidth - 200) * 0.5;

        btnInCloud.y = StarlingRoot.GAP;
        btnInCloud.addEventListener(TouchEvent.TOUCH, OnCloudClick);
        addChild(btnInCloud);

        btnDocumentInCloud.y = btnInCloud.y + StarlingRoot.GAP;
        btnDocumentInCloud.addEventListener(TouchEvent.TOUCH, OnDocumentCloudClick);
        addChild(btnDocumentInCloud);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnDocumentInCloud.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        textImageDisplay = new Image(Texture.fromBitmap(bmpTextImage));
        textContainer.addChild(textImageDisplay);
        cloudTextImageDisplay = new Image(Texture.fromBitmap(bmpCloudTextImage));
        textContainer.addChild(cloudTextImageDisplay);
        cloudDocumentImageDisplay = new Image(Texture.fromBitmap(bmpCloudDocumentImage));
        cloudDocumentImageDisplay.scale = 0.3;
        textContainer.addChild(cloudDocumentImageDisplay);
        textImageDisplay.visible = false;

        var newScale:Number = (stageWidth - 30) / textContainer.width;
        textContainer.scaleY = textContainer.scaleX = newScale;
        textContainer.visible = false;
        textContainer.x = (stageWidth - textContainer.width) * 0.5;
        textContainer.y = statusLabel.y + StarlingRoot.GAP;

        textContainer.addChild(overlayContainer);
        addChild(textContainer);
    }

    private function OnCloudClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnInCloud);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            clearOverlay();
            textContainer.visible = true;
            textImageDisplay.visible = false;
            cloudDocumentImageDisplay.visible = false;
            cloudTextImageDisplay.visible = true;
            var visionImage:VisionImage = new VisionImage(bmpCloudTextImage.bitmapData);
            cloudTextRecognizer.process(visionImage, onProcessed);
        }
    }

    private function OnDocumentCloudClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDocumentInCloud);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            clearOverlay();
            textContainer.visible = true;
            textImageDisplay.visible = false;
            cloudTextImageDisplay.visible = false;
            cloudDocumentImageDisplay.visible = true;

            var visionImage:VisionImage = new VisionImage(bmpCloudDocumentImage.bitmapData);
            cloudDocumentRecognizer.process(visionImage, onDocumentProcessed);
        }
    }

    private function onProcessed(text:CloudText, error:CloudTextError):void {
        cloudTextRecognizer.close();
        if (error) {
            statusLabel.text = "Text error: " + error.errorID + " : " + error.message;
            return;
        }
        trace(text.text);
        for each (var block:CloudTextBlock in text.blocks) {
            for each (var line:CloudTextLine in block.lines) {
                var frame:Rectangle;
                for each (var element:CloudTextElement in line.elements) {
                    frame = element.frame;
                    var hl:TextElementHighlight = new TextElementHighlight(frame, element.text);
                    overlayContainer.addChild(hl);
                }
            }
        }
    }

    private function onDocumentProcessed(document:DocumentText, error:CloudTextError):void {
        cloudDocumentRecognizer.close();
        if (error) {
            statusLabel.text = "Text error: " + error.errorID + " : " + error.message;
            return;
        }
        trace(document.text);
        var blocks:Vector.<DocumentTextBlock> = document.blocks;
        if (blocks.length > 0) {
            var block:DocumentTextBlock = blocks[0];
            if (block != null) {
                trace("block.paragraphs.length", block.paragraphs.length);
            }
        }
        document.dispose();
    }

    private function clearOverlay():void {
        while (overlayContainer.numChildren > 0) {
            overlayContainer.removeChildAt(0);
        }
    }

}
}
