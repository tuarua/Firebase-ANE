package views.examples {
import com.tuarua.firebase.StorageANE;
import com.tuarua.firebase.storage.DownloadTask;
import com.tuarua.firebase.storage.StorageError;
import com.tuarua.firebase.storage.StorageMetadata;
import com.tuarua.firebase.storage.StorageReference;
import com.tuarua.firebase.storage.UploadTask;
import com.tuarua.firebase.storage.events.StorageErrorEvent;
import com.tuarua.firebase.storage.events.StorageEvent;
import com.tuarua.firebase.storage.events.StorageProgressEvent;

import flash.display.Bitmap;

import flash.display.Loader;
import flash.events.Event;
import flash.filesystem.File;
import flash.net.URLRequest;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;

import views.SimpleButton;

public class StorageExample extends Sprite implements IExample {
    private var storage:StorageANE;
    private var storageRef:StorageReference;
    private var btnGetMetadata:SimpleButton = new SimpleButton("Get File Metadata");
    private var btnUpdateMetadata:SimpleButton = new SimpleButton("Update File Metadata");
    private var btnGetUrl:SimpleButton = new SimpleButton("Get Url");
    private var btnDownloadBytes:SimpleButton = new SimpleButton("Download Bytes");
    private var btnDownloadFile:SimpleButton = new SimpleButton("Download File");
    private var btnUploadFile:SimpleButton = new SimpleButton("Upload File");
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var isInited:Boolean;

    public function StorageExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
        copyFiles();
    }

    public function initANE():void {
        if (isInited) return;

        storage = StorageANE.storage;
        trace("storage.maxDownloadRetryTime", storage.maxDownloadRetryTime);
        trace("storage.maxOperationRetryTime", storage.maxOperationRetryTime);
        trace("storage.maxUploadRetryTime", storage.maxUploadRetryTime);

        storageRef = storage.reference("images/logo.png");
        trace(storageRef.path, storageRef.name, storageRef.bucket);

        isInited = true;
    }


    private function initMenu():void {
        statusLabel = new TextField(stageWidth - 100, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.wordWrap = true;
        statusLabel.touchable = false;
        statusLabel.x = 50;

        addChild(statusLabel);

        btnGetUrl.x = btnUpdateMetadata.x = btnDownloadFile.x = btnGetMetadata.x = btnDownloadBytes.x =
                btnUploadFile.x = (stageWidth - 200) * 0.5;

        btnGetMetadata.addEventListener(TouchEvent.TOUCH, onGetMetaClick);
        btnGetMetadata.y = StarlingRoot.GAP;
        addChild(btnGetMetadata);

        btnUpdateMetadata.addEventListener(TouchEvent.TOUCH, onUpdateMetaClick);
        btnUpdateMetadata.y = btnGetMetadata.y + StarlingRoot.GAP;
        addChild(btnUpdateMetadata);

        btnGetUrl.addEventListener(TouchEvent.TOUCH, onGetUrlClick);
        btnGetUrl.y = btnUpdateMetadata.y + StarlingRoot.GAP;
        addChild(btnGetUrl);

        btnDownloadBytes.addEventListener(TouchEvent.TOUCH, onDownloadBytesClick);
        btnDownloadBytes.y = btnGetUrl.y + StarlingRoot.GAP;
        addChild(btnDownloadBytes);

        btnDownloadFile.addEventListener(TouchEvent.TOUCH, onDownloadFileClick);
        btnDownloadFile.y = btnDownloadBytes.y + StarlingRoot.GAP;
        addChild(btnDownloadFile);

        btnUploadFile.addEventListener(TouchEvent.TOUCH, onUploadFileClick);
        btnUploadFile.y = btnDownloadFile.y + StarlingRoot.GAP;
        addChild(btnUploadFile);

        statusLabel.y = btnUploadFile.y + (StarlingRoot.GAP * 1.25);

    }

    private function onGetUrlClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetUrl);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            storageRef.downloadUrl(onGetUrl);
        }
    }

    private function onGetMetaClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetMetadata);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            storageRef.getMetadata(onGetMetadata);
        }
    }

    private function onUpdateMetaClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUpdateMetadata);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var newMeta:StorageMetadata = new StorageMetadata();
            newMeta.contentLanguage = "en";
            trace(newMeta.contentLanguage);

            storageRef.updateMetadata(newMeta, onMetadataUpdated);
        }
    }

    private function onDownloadBytesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDownloadBytes);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var downloadTask:DownloadTask = storageRef.getData(); // Progress is not available for getBytes()
            downloadTask.addEventListener(StorageEvent.TASK_COMPLETE, onDownloadBytesSuccess, false, 0, true);
            downloadTask.addEventListener(StorageErrorEvent.ERROR, onDownloadError, false, 0, true)
        }
    }

    private function onDownloadFileClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDownloadFile);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var downloadTask:DownloadTask = storageRef.write(File.applicationStorageDirectory.resolvePath("downloaded-logo.png"));
            downloadTask.addEventListener(StorageProgressEvent.PROGRESS, onDownloadProgress);
            downloadTask.addEventListener(StorageEvent.TASK_COMPLETE, onDownloadFileSuccess, false, 0, true);
            downloadTask.addEventListener(StorageErrorEvent.ERROR, onDownloadError, false, 0, true)
        }
    }

    private function onUploadFileClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUploadFile);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var imageFile:File = File.applicationStorageDirectory.resolvePath("local-logo.png");
            trace("imageFile.exists", imageFile.exists);
            if (!imageFile.exists) return;
            var storageRef:StorageReference = storage.reference("images/uploaded-logo.png");
            var uploadTask:UploadTask = storageRef.putFile(imageFile);
            uploadTask.addEventListener(StorageProgressEvent.PROGRESS, onUploadProgress);
            uploadTask.addEventListener(StorageEvent.TASK_COMPLETE, onUploadFileSuccess, false, 0, true);
            uploadTask.addEventListener(StorageErrorEvent.ERROR, onUploadError, false, 0, true);
        }
    }

    private function onUploadProgress(event:StorageProgressEvent):void {
        trace(event);
        statusLabel.text = Math.floor((event.bytesLoaded / event.bytesTotal) * 100) + "% uploaded";
    }

    private function onDownloadProgress(event:StorageProgressEvent):void {
        trace(event);
        statusLabel.text = Math.floor((event.bytesLoaded / event.bytesTotal) * 100) + "% downloaded";
    }

    private function onUploadFileSuccess(event:StorageEvent):void {
        statusLabel.text = "Upload complete";
    }

    private function onUploadError(event:StorageErrorEvent):void {
        trace(event);
        statusLabel.text = "Upload error: " + event.errorID + " : " + event.text;
    }

    private function onDownloadError(event:StorageErrorEvent):void {
        trace(event);
        statusLabel.text = "Download error: " + event.errorID + " : " + event.text;
    }

    private function onGetUrl(url:String, error:StorageError):void {
        if (error) {
            statusLabel.text = "GetUrl error: " + error.errorID + " : " + error.message;
            return;
        }
        if (url) {
            statusLabel.text = "name: " + url;
        }
    }

    private function onGetMetadata(metadata:StorageMetadata, error:StorageError):void {
        if (error) {
            statusLabel.text = "GetMetadata error: " + error.errorID + " : " + error.message;
            return
        }
        if (metadata) {
            statusLabel.text = "name: " + metadata.name + "\n" +
                    "bucket: " + metadata.bucket + "\n" +
                    "path: " + metadata.path + "\n" +
                    "cacheControl: " + metadata.cacheControl + "\n" +
                    "contentDisposition: " + metadata.contentDisposition + "\n" +
                    "contentEncoding: " + metadata.contentEncoding + "\n" +
                    "contentLanguage: " + metadata.contentLanguage + "\n" +
                    "contentType: " + metadata.contentType + "\n" +
                    "creation: " + new Date(metadata.creationTime) + "\n" +
                    "updated: " + new Date(metadata.updatedTime) + "\n" +
                    "size: " + metadata.size + "\n";
        }
    }

    private function onMetadataUpdated(error:StorageError):void {
        if (error) {
            statusLabel.text = "MetadataUpdate error: " + error.errorID + " : " + error.message;
            return
        }
        statusLabel.text = "Metadata updated";
    }

    private function onDownloadFileSuccess(event:StorageEvent):void {
        statusLabel.text = "Download complete";
        var file:File = event.localFile;
        if (file) {
            var ldr:Loader = new Loader();
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete, false, 0, true);
            ldr.load(new URLRequest("file://" + encodeURI(file.nativePath)));
            function ldr_complete(evt:Event):void {
                renderImage(ldr.content as Bitmap);
            }
        }
    }

    private function onDownloadBytesSuccess(event:StorageEvent):void {
        if (event.bytes) {
            var ldr:Loader = new Loader();
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete);
            ldr.loadBytes(event.bytes);

            function ldr_complete(evt:Event):void {
                renderImage(ldr.content as Bitmap);
            }
        }
    }

    private function renderImage(bmp:Bitmap):void {
        var image:Image = new Image(Texture.fromBitmap(bmp));
        image.x = (stageWidth - 167) * 0.5;
        image.y = btnUploadFile.y + StarlingRoot.GAP;
        image.touchable = false;
        image.alpha = 0;
        addChild(image);
        var tween:Tween = new Tween(image, 0.5);
        tween.animate("alpha", 1.0);
        Starling.juggler.add(tween);
    }

    private static function copyFiles():void {
        var inFile1:File = File.applicationDirectory.resolvePath("local-logo.png");
        var outFile1:File = File.applicationStorageDirectory.resolvePath("local-logo.png");
        if (inFile1.exists) {
            inFile1.copyTo(outFile1, true);
        } else {
            trace("logo.png doesn't exist");
        }
    }

}
}
