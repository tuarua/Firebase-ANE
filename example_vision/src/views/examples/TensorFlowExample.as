package views.examples {

import com.tuarua.firebase.ml.common.modeldownload.ModelDownloadConditions;
import com.tuarua.firebase.ml.common.modeldownload.ModelManager;
import com.tuarua.firebase.ml.custom.CustomLocalModel;
import com.tuarua.firebase.ml.custom.CustomRemoteModel;
import com.tuarua.firebase.ml.custom.ModelElementType;
import com.tuarua.firebase.ml.custom.ModelInputOutputOptions;
import com.tuarua.firebase.ml.custom.ModelInputs;
import com.tuarua.firebase.ml.custom.ModelInterpreter;
import com.tuarua.firebase.ml.custom.ModelInterpreterError;
import com.tuarua.firebase.ml.custom.ModelInterpreterOptions;

import flash.display.Bitmap;
import flash.filesystem.File;
import flash.utils.ByteArray;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class TensorFlowExample extends Sprite implements IExample {
    [Embed(source="../../../assets/dog.jpg")]
    public static const dogImageBitmap:Class;
    private var bmpLandmarkImage:Bitmap = new dogImageBitmap() as Bitmap;
    private static const IMAGE_BATCH_SIZE:int = 1;
    private static const IMAGE_PIXEL_SIZE:int = 3;
    private static const IMAGE_SIZE_X:int = 299;
    private static const IMAGE_SIZE_Y:int = 299;

    private var btnIdentify:SimpleButton = new SimpleButton("Identify Dog");
    private var btnDownload:SimpleButton = new SimpleButton("Download remote model");
    private var btnDeleteDownload:SimpleButton = new SimpleButton("Delete Download");
    private var textContainer:Sprite = new Sprite();
    private var statusLabel:TextField;

    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var modelInterpreter:ModelInterpreter;
    private var modelManager:ModelManager;

    public function TensorFlowExample(stageWidth:int) {
        super();
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    private function initMenu():void {
        btnDeleteDownload.x = btnDownload.x = btnIdentify.x = (stageWidth - 200) * 0.5;

        btnIdentify.y = StarlingRoot.GAP;
        btnIdentify.addEventListener(TouchEvent.TOUCH, OnIdentifyClick);
        addChild(btnIdentify);

        btnDownload.y = btnIdentify.y + StarlingRoot.GAP;
        btnDownload.addEventListener(TouchEvent.TOUCH, OnIsDownloadedClick);
        addChild(btnDownload);

        btnDeleteDownload.visible = false;
        btnDeleteDownload.y = btnDownload.y;
        btnDeleteDownload.addEventListener(TouchEvent.TOUCH, OnDeleteDownloadClick);
        addChild(btnDeleteDownload);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnDownload.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        var newScale:Number = (stageWidth - 30) / textContainer.width;
        textContainer.scaleY = textContainer.scaleX = newScale;

        textContainer.x = (stageWidth - textContainer.width) * 0.5;
        textContainer.y = statusLabel.y + StarlingRoot.GAP;

        addChild(textContainer);
    }

    public function initANE():void {
        if (isInited) return;
        var testFile:File = File.applicationDirectory.resolvePath("mobilenet").resolvePath("mobilenet_quant_v2_1.0_299.tflite");
        if (!testFile.exists) {
            statusLabel.text = "Can't find mobilenet tflite file";
            return;
        }
        var options:ModelInterpreterOptions = new ModelInterpreterOptions(new CustomLocalModel("mobilenet/mobilenet_quant_v2_1.0_299.tflite"));
        modelInterpreter = ModelInterpreter.shared(options);
        modelManager = ModelInterpreter.modelManager;
        isInited = true;
    }

    private function OnIsDownloadedClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDownload);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var remoteCustomModel:CustomRemoteModel = new CustomRemoteModel("Test-Custom-Remote");
            modelManager.isModelDownloaded(remoteCustomModel, function (result:Boolean):void {
                if (result) {
                    statusLabel.text = "Model is already Downloaded";
                    btnDeleteDownload.visible = true;
                    btnDownload.visible = false;
                    return;
                }
                // We haven't got the model so download it!
                var conditions:ModelDownloadConditions = new ModelDownloadConditions(true);
                modelManager.download(remoteCustomModel, conditions, function (error:ModelInterpreterError):void {
                    if (error) {
                        statusLabel.text = "Tensor Flow error: " + error.errorID + " : " + error.message;
                        return;
                    }
                    statusLabel.text = "Model Downloaded: " + remoteCustomModel.name;
                    btnDeleteDownload.visible = true;
                    btnDownload.visible = false;
                });
            });
        }
    }

    private function OnDeleteDownloadClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDeleteDownload);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var remoteCustomModel:CustomRemoteModel = new CustomRemoteModel("Test-Custom-Remote");
            modelManager.deleteDownloadedModel(remoteCustomModel, function (result:Boolean):void {
                btnDeleteDownload.visible = !result;
                btnDownload.visible = result;
                statusLabel.text = "Download deleted: " + result;
            });
        }
    }

    private function OnIdentifyClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnIdentify);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

            // convert bitmap into byte array of ModelElementType.byte
            var pixels:ByteArray = new ByteArray();
            for (var i:int = 0; i < IMAGE_SIZE_X; ++i) {
                for (var j:int = 0; j < IMAGE_SIZE_Y; ++j) {
                    var pixelValue:uint = bmpLandmarkImage.bitmapData.getPixel(i, j);
                    pixels.writeByte(pixelValue >> 16 & 0xFF); //red
                    pixels.writeByte(pixelValue >> 8 & 0xFF); //green
                    pixels.writeByte(pixelValue & 0xFF); //blue
                }
            }
            var inputs:ModelInputs = new ModelInputs();
            inputs.addInput(pixels);
            var inputOutputOptions:ModelInputOutputOptions = new ModelInputOutputOptions();
            inputOutputOptions.setInputFormat(0, ModelElementType.byte, [IMAGE_BATCH_SIZE, IMAGE_SIZE_X, IMAGE_SIZE_Y, IMAGE_PIXEL_SIZE]);
            inputOutputOptions.setOutputFormat(0, ModelElementType.byte, [1, MobileNet.labels.length]);

            modelInterpreter.run(inputs, inputOutputOptions, function (results:Array, error:ModelInterpreterError):void {
                if (error) {
                    statusLabel.text = "Tensor Flow error: " + error.errorID + " : " + error.message;
                    return;
                }
                for each(var result:Object in results) {
                    statusLabel.text = statusLabel.text + MobileNet.labels[result.index] + " : "
                            + Math.floor(result.confidence * 100) + "%\n";
                }
            }, MobileNet.labels.length, 5);
        }
    }

}
}
