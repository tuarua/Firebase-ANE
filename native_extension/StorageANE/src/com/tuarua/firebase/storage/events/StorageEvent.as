package com.tuarua.firebase.storage.events {
import com.tuarua.firebase.storage.StorageMetadata;

import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class StorageEvent extends Event {
    public static const GET_DOWNLOAD_URL: String = "StorageEvent.GetDownloadUrl";
    public static const GET_METADATA: String = "StorageEvent.GetMetadata";
    public static const UPDATE_METADATA: String = "StorageEvent.UpdateMetadata";
    public static const COMPLETE: String = "StorageEvent.TaskComplete";
    public var localFile:File;
    public var downloadUrl:String;
    public var bytes:ByteArray;
    public var metadata:StorageMetadata;
    public function StorageEvent(type:String, localFile:File = null, bytes:ByteArray = null, downloadUrl:String = null,
                                 metadata:StorageMetadata = null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.localFile = localFile;
        this.downloadUrl = downloadUrl;
        this.bytes = bytes;
        this.metadata = metadata;
    }
    public override function clone():Event {
        return new StorageEvent(type, this.localFile, this.bytes, this.downloadUrl, this.metadata, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("StorageEvent", "localFile", "downloadUrl", "type", "bubbles", "cancelable");
    }
}
}
