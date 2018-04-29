package views.examples {
import com.tuarua.firebase.StorageANE;
import com.tuarua.firebase.storage.DownloadTask;
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

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;

import views.SimpleButton;

public class StorageExample extends Sprite {
    private var storage:StorageANE;
    private var storageRef:StorageReference;
    private var btnGetMetadata:SimpleButton = new SimpleButton("Get File Metadata");
    private var btnUpdateMetadata:SimpleButton = new SimpleButton("Update File Metadata");
    private var btnDownloadBytes:SimpleButton = new SimpleButton("Download Bytes");
    private var btnDownloadFile:SimpleButton = new SimpleButton("Download File");
    private var btnUploadFile:SimpleButton = new SimpleButton("Upload File");
    private var statusLabel:TextField;
    private var stageWidth:Number;

    public function StorageExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;

        storage = StorageANE.storage;
        trace("storage.maxDownloadRetryTime", storage.maxDownloadRetryTime);
        trace("storage.maxOperationRetryTime", storage.maxOperationRetryTime);
        trace("storage.maxUploadRetryTime", storage.maxUploadRetryTime);

        storageRef = storage.getReference("images/logo.png");
        storageRef.addEventListener(StorageErrorEvent.ERROR, onError);
        storageRef.addEventListener(StorageEvent.GET_METADATA, onGetMetadata);
        storageRef.addEventListener(StorageEvent.UPDATE_METADATA, onMetadataUpdated);
        trace(storageRef.path, storageRef.name, storageRef.bucket);

        initMenu();

        copyFiles();
    }


    private function initMenu():void {
        statusLabel = new TextField(stageWidth - 100, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.wordWrap = true;
        statusLabel.touchable = false;
        statusLabel.x = 50;

        addChild(statusLabel);

        btnUpdateMetadata.x = btnDownloadFile.x = btnGetMetadata.x = btnDownloadBytes.x = btnUploadFile.x = (stageWidth - 200) * 0.5;

        btnGetMetadata.addEventListener(TouchEvent.TOUCH, onGetMetaClick);
        btnGetMetadata.y = StarlingRoot.GAP;
        addChild(btnGetMetadata);

        btnUpdateMetadata.addEventListener(TouchEvent.TOUCH, onUpdateMetaClick);
        btnUpdateMetadata.y = btnGetMetadata.y + StarlingRoot.GAP;
        addChild(btnUpdateMetadata);

        btnDownloadBytes.addEventListener(TouchEvent.TOUCH, onDownloadBytesClick);
        btnDownloadBytes.y = btnUpdateMetadata.y + StarlingRoot.GAP;
        addChild(btnDownloadBytes);

        btnDownloadFile.addEventListener(TouchEvent.TOUCH, onDownloadFileClick);
        btnDownloadFile.y = btnDownloadBytes.y + StarlingRoot.GAP;
        addChild(btnDownloadFile);

        btnUploadFile.addEventListener(TouchEvent.TOUCH, onUploadFileClick);
        btnUploadFile.y = btnDownloadFile.y + StarlingRoot.GAP;
        addChild(btnUploadFile);

        statusLabel.y = btnUploadFile.y + (StarlingRoot.GAP * 2);

    }

    private function onGetMetaClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetMetadata);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            storageRef.getMetadata();
        }
    }

    private function onUpdateMetaClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUpdateMetadata);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var newMeta:StorageMetadata = new StorageMetadata();
            newMeta.contentLanguage = "en";
            trace(newMeta.contentLanguage);

            storageRef.updateMetadata(newMeta);
        }
    }

    private function onError(event:StorageErrorEvent):void {
        trace(event.text);
        statusLabel.text = "Error: " + event.errorID + " : " +event.text;
    }

    private function onDownloadBytesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDownloadBytes);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var downloadTask:DownloadTask = storageRef.getBytes(); // Progress is not available for getBytes()
            downloadTask.addEventListener(StorageEvent.COMPLETE, onDownloadBytesSuccess, false, 0, true);
            downloadTask.addEventListener(StorageErrorEvent.ERROR, onDownloadError, false, 0, true)
        }
    }

    private function onDownloadFileClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnDownloadFile);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var downloadTask:DownloadTask = storageRef.getFile(File.applicationStorageDirectory.resolvePath("downloaded-logo.png"));
            downloadTask.addEventListener(StorageProgressEvent.PROGRESS, onDownloadProgress);
            downloadTask.addEventListener(StorageEvent.COMPLETE, onDownloadFileSuccess, false, 0, true);
            downloadTask.addEventListener(StorageErrorEvent.ERROR, onDownloadError, false, 0, true)
        }
    }

    private function onUploadFileClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnUploadFile);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var imageFile:File = File.applicationStorageDirectory.resolvePath("local-logo.png");
            trace("imageFile.exists", imageFile.exists);
            if (!imageFile.exists) return;
            var storageRef:StorageReference = storage.getReference("images/uploaded-logo.png");
            var uploadTask:UploadTask = storageRef.putFile(imageFile);
            uploadTask.addEventListener(StorageProgressEvent.PROGRESS, onUploadProgress);
            uploadTask.addEventListener(StorageEvent.COMPLETE, onUploadFileSuccess, false, 0, true);
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
        var task:UploadTask = event.currentTarget as UploadTask;
        task.removeEventListener(StorageEvent.COMPLETE, onUploadFileSuccess);
        task.removeEventListener(StorageProgressEvent.PROGRESS, onUploadProgress);
        task.removeEventListener(StorageErrorEvent.ERROR, onUploadError);
        statusLabel.text = "Upload complete";
    }

    private function onUploadError(event:StorageErrorEvent):void {
        trace(event);
        statusLabel.text = "Upload error: " + event.errorID + " : " + event.text;
    }

    private function onDownloadError(event:StorageErrorEvent):void {
        trace(event);

        // Android [trace] [ErrorEvent type="StorageErrorEvent.Error" bubbles=true cancelable=false eventPhase=2 text="User does not have permission to access this object." errorID=-13021]

        statusLabel.text = "Download error: " + event.errorID + " : " + event.text;
    }

    private function onGetMetadata(event:StorageEvent):void {
        var metadata:StorageMetadata = event.metadata;
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

    private function onMetadataUpdated(event:StorageEvent):void {
        statusLabel.text = "Metadata updated";
    }

    private function onDownloadFileSuccess(event:StorageEvent):void {
        var file:File = event.localFile;
        trace("onDownloadFileSuccess", file, file.exists);
        trace(event);
        if (file) {
            var ldr:Loader = new Loader();
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete, false, 0, true);
            ldr.load(new URLRequest("file://" + encodeURI(file.nativePath)));

            function ldr_complete(evt:Event):void {
                var image:Image = new Image(Texture.fromBitmap(ldr.content as Bitmap));
                image.x = (stageWidth - 167) * 0.5;
                image.y = btnUploadFile.y + StarlingRoot.GAP;
                addChild(image);
            }
        }
    }

    private function onDownloadBytesSuccess(event:StorageEvent):void {
        var task:DownloadTask = event.currentTarget as DownloadTask;
        task.removeEventListener(StorageEvent.COMPLETE, onUploadFileSuccess);
        task.removeEventListener(StorageProgressEvent.PROGRESS, onUploadProgress);
        task.removeEventListener(StorageErrorEvent.ERROR, onUploadError);
        if (event.bytes) {
            var ldr:Loader = new Loader();
            ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, ldr_complete);
            ldr.loadBytes(event.bytes);

            function ldr_complete(evt:Event):void {
                var image:Image = new Image(Texture.fromBitmap(ldr.content as Bitmap));
                image.x = (stageWidth - 167) * 0.5;
                image.y = btnUploadFile.y + StarlingRoot.GAP;
                addChild(image);
            }
        }
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
