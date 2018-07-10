package views.examples {

import com.tuarua.firebase.BarcodeError;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.BarcodeDetector;
import com.tuarua.firebase.vision.Barcode;
import com.tuarua.firebase.vision.BarcodeDetectorOptions;
import com.tuarua.firebase.vision.BarcodeFormat;
import com.tuarua.firebase.vision.VisionImage;

import flash.display.Bitmap;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class BarcodeExample extends Sprite implements IExample {

    [Embed(source="../../../assets/qr-code.jpg")]
    public static const qrBitmap:Class;

    private var btnQrCode:SimpleButton = new SimpleButton("QR Code");
    private var btn2:SimpleButton = new SimpleButton("Placeholder");
    private var btn3:SimpleButton = new SimpleButton("Placeholder");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var isInited:Boolean;
    private var barcodeDetector:BarcodeDetector;
    private var vision:VisionANE;

    public function BarcodeExample(stageWidth:Number, vision:VisionANE) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;
//        var options:BarcodeDetectorOptions = new BarcodeDetectorOptions();
//        options.formats = new <int>[BarcodeFormat.qrCode];
        this.barcodeDetector = vision.barcodeDetector();
        isInited = true;
    }

    private function initMenu():void {
        btn3.x = btn2.x = btnQrCode.x = (stageWidth - 200) * 0.5;
        btnQrCode.y = StarlingRoot.GAP;
        btnQrCode.addEventListener(TouchEvent.TOUCH, onQrCodeClick);
        addChild(btnQrCode);

        btn2.y = btnQrCode.y + StarlingRoot.GAP;
        btn2.addEventListener(TouchEvent.TOUCH, on2Click);
        addChild(btn2);

        btn3.y = btn2.y + StarlingRoot.GAP;
        btn3.addEventListener(TouchEvent.TOUCH, on3Click);
        addChild(btn3);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btn3.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

    }

    private function onQrCodeClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnQrCode);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var barcodeImage:VisionImage = new VisionImage((new qrBitmap() as Bitmap).bitmapData);
            barcodeDetector.detect(barcodeImage,
                    function (features:Vector.<Barcode>, error:BarcodeError):void {
                        statusLabel.text = "";
                        if (error) {
                            statusLabel.text = "Barcode error: " + error.errorID + " : " + error.message;
                            return;
                        }
                        for each (var barcode:Barcode in features) {
                            statusLabel.text += "rawValue: "+ barcode.rawValue + "\n";
                        }
                    });
        }
    }

    private function on2Click(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn2);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

        }
    }

    private function on3Click(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btn3);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

        }
    }

}
}
