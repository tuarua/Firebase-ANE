package views.examples {

import com.tuarua.firebase.BarcodeDetector;
import com.tuarua.firebase.BarcodeError;
import com.tuarua.firebase.VisionANE;
import com.tuarua.firebase.vision.Barcode;
import com.tuarua.firebase.vision.BarcodeDetectorOptions;
import com.tuarua.firebase.vision.BarcodeFormat;
import com.tuarua.firebase.vision.VisionImage;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;

import roipeker.display.MeshRoundRect;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import views.SimpleButton;

public class BarcodeExample extends Sprite implements IExample {

    [Embed(source="../../../assets/qr-code.jpg")]
    public static const QrBitmap:Class;

    [Embed(source="../../../assets/barcode_128.png")]
    public static const BarcodeBitmap:Class;

    private var bmpQr:Bitmap = new QrBitmap() as Bitmap;
    private var bmpBarcode:Bitmap = new BarcodeBitmap() as Bitmap;

    private var qrDisplay:Image = new Image(Texture.fromBitmap(bmpQr));
    private var barcodeDisplay:Image = new Image(Texture.fromBitmap(bmpBarcode));

    private var btnClose:SimpleButton = new SimpleButton("Close");
    private var btnQrCode:SimpleButton = new SimpleButton("QR Code");
    private var btnBarcode128:SimpleButton = new SimpleButton("Barcode 128");
    private var btnCamera:SimpleButton = new SimpleButton("Scan with Camera");
    private var statusLabel:TextField;

    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var barcodeDetector:BarcodeDetector;
    private var vision:VisionANE;
    private var infoBox:MeshRoundRect;

    public function BarcodeExample(stageWidth:Number, stageHeight:Number, vision:VisionANE) {
        super();
        this.vision = vision;
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;

        barcodeDetector = vision.barcodeDetector();
        isInited = true;
    }

    private function initMenu():void {
        btnClose.x = btnCamera.x = btnBarcode128.x = btnQrCode.x = (stageWidth - 200) * 0.5;
        btnClose.y = btnQrCode.y = StarlingRoot.GAP;
        btnQrCode.addEventListener(TouchEvent.TOUCH, onQrCodeClick);
        addChild(btnQrCode);

        btnBarcode128.y = btnQrCode.y + StarlingRoot.GAP;
        btnBarcode128.addEventListener(TouchEvent.TOUCH, onBarcodeClick);
        addChild(btnBarcode128);

        btnCamera.y = btnBarcode128.y + StarlingRoot.GAP;
        btnCamera.addEventListener(TouchEvent.TOUCH, onCameraClick);
        addChild(btnCamera);

        infoBox = new MeshRoundRect();
        infoBox.setup(300, 40, 10);
        infoBox.color = Color.WHITE;
        infoBox.x = (stageWidth - 300) * 0.5;
        infoBox.y = btnCamera.y + StarlingRoot.GAP + 5;
        infoBox.visible = false;
        addChild(infoBox);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnCamera.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        barcodeDisplay.scaleY = barcodeDisplay.scaleX = 0.20; // barcode is a little big

        barcodeDisplay.x = (stageWidth - barcodeDisplay.width) * 0.5;
        qrDisplay.x = (stageWidth - qrDisplay.width) * 0.5;
        barcodeDisplay.y = qrDisplay.y = statusLabel.y + StarlingRoot.GAP;
        qrDisplay.visible = barcodeDisplay.visible = false;
        addChild(qrDisplay);
        addChild(barcodeDisplay);

        btnClose.addEventListener(TouchEvent.TOUCH, onCloseClick);
        btnClose.visible = false;
        addChild(btnClose);


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
                            statusLabel.text += "rawValue: " + barcode.rawValue + "\n";
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
                            statusLabel.text += "rawValue: " + barcode.rawValue + "\n";
                        }
                    });
        }
    }

    private function onCameraClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCamera);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            // TODO
//            qrDisplay.visible = false;
//            barcodeDisplay.visible = false;
//            btnCamera.visible = btnBarcode128.visible = btnQrCode.visible = false;
//
//            btnClose.visible = true;
//            infoBox.visible = true;
//            statusLabel.text = "Find a book to scan";
//
//            var maskBmd:BitmapData = new BitmapData(Starling.current.nativeStage.fullScreenWidth,
//                    Starling.current.nativeStage.fullScreenHeight, true, 0x00FFFFFF); //the full size mask
//
//            var spriteBmd:BitmapData = new BitmapData(this.width * 2, this.height * 2, true, 0xFFFFFFFF);
//            this.drawToBitmapData(spriteBmd);
//            maskBmd.copyPixels(spriteBmd, spriteBmd.rect, new Point(this.bounds.x * 2, this.bounds.y * 2));
//
//            var options:BarcodeDetectorOptions = new BarcodeDetectorOptions();
//            options.formats = new <int>[BarcodeFormat.EAN13]; //ISBN barcode from a book
//            barcodeDetector.options = options;
//            barcodeDetector.inputFromCamera(function (features:Vector.<Barcode>, error:BarcodeError):void {
//                if (error) {
//                    // statusLabel.text = "Barcode error: " + error.errorID + " : " + error.message;
//                    return;
//                }
//                for each (var barcode:Barcode in features) {
//                    statusLabel.text = barcode.rawValue + "\n";
//                }
//            }, maskBmd);

        }
    }

    private function onCloseClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnClose);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            // barcodeDetector.closeCamera();
            btnClose.visible = false;
            btnCamera.visible = btnBarcode128.visible = btnQrCode.visible = true;
            statusLabel.text = "";
        }
    }

}
}
