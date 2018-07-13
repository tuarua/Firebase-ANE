package views.examples {

import com.tuarua.firebase.BarcodeError;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.BarcodeDetector;
import com.tuarua.firebase.vision.Barcode;
import com.tuarua.firebase.vision.BarcodeDetectorOptions;
import com.tuarua.firebase.vision.BarcodeFormat;
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

public class BarcodeExample extends Sprite implements IExample {

    [Embed(source="../../../assets/qr-code.jpg")]
    public static const qrBitmap:Class;

    [Embed(source="../../../assets/barcode_128.png")]
    public static const barcodeBitmap:Class;

    private var bmpQr:Bitmap = new qrBitmap() as Bitmap;
    private var bmpBarcode:Bitmap = new barcodeBitmap() as Bitmap;

    private var qrDisplay:Image;
    private var barcodeDisplay:Image;

    private var btnQrCode:SimpleButton = new SimpleButton("QR Code");
    private var btnBarcode128:SimpleButton = new SimpleButton("Barcode 128");
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

        barcodeDetector = vision.barcodeDetector();
        isInited = true;
    }

    private function initMenu():void {
        btnBarcode128.x = btnQrCode.x = (stageWidth - 200) * 0.5;
        btnQrCode.y = StarlingRoot.GAP;
        btnQrCode.addEventListener(TouchEvent.TOUCH, onQrCodeClick);
        addChild(btnQrCode);

        btnBarcode128.y = btnQrCode.y + StarlingRoot.GAP;
        btnBarcode128.addEventListener(TouchEvent.TOUCH, onBarcodeClick);
        addChild(btnBarcode128);


        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnBarcode128.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        qrDisplay = new Image(Texture.fromBitmap(bmpQr));
        barcodeDisplay = new Image(Texture.fromBitmap(bmpBarcode));
        barcodeDisplay.scaleY = barcodeDisplay.scaleX = 0.25; // barcode is a little big

        barcodeDisplay.x = (stageWidth - barcodeDisplay.width) * 0.5;
        qrDisplay.x = (stageWidth - qrDisplay.width) * 0.5;
        barcodeDisplay.y = qrDisplay.y = statusLabel.y + (StarlingRoot.GAP * 1.25);
        qrDisplay.visible = barcodeDisplay.visible = false;
        addChild(qrDisplay);
        addChild(barcodeDisplay);

    }

    private function onQrCodeClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnQrCode);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            qrDisplay.visible = true;
            barcodeDisplay.visible = false;
            var visionImage:VisionImage = new VisionImage(bmpQr.bitmapData);

            var options:BarcodeDetectorOptions = new BarcodeDetectorOptions();
            options.formats = new <int>[BarcodeFormat.qrCode];
            barcodeDetector.options = options;
            barcodeDetector.detect(visionImage,
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

    private function onBarcodeClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnBarcode128);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            qrDisplay.visible = false;
            barcodeDisplay.visible = true;

            var visionImage:VisionImage = new VisionImage(bmpBarcode.bitmapData);

            var options:BarcodeDetectorOptions = new BarcodeDetectorOptions();
            options.formats = new <int>[BarcodeFormat.code128];
            barcodeDetector.options = options;
            barcodeDetector.detect(visionImage,
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

}
}
