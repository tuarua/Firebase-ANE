package com.tuarua.firebase.storage {
import com.tuarua.firebase.StorageANEContext;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;
import flash.filesystem.File;
import flash.utils.ByteArray;

public class StorageReference extends EventDispatcher {
    private var _bucket:String;
    private var _name:String;
    private var _path:String;
    private var _url:String;
    private var _asId:String;
    private var _root:StorageReference;
    private var _parent:StorageReference;

    public function StorageReference(path:String = null, url:String = null, bucket:String = null, name:String = null, isRoot:Boolean = false) {
        this._path = path;
        this._url = url;
        this._bucket = bucket;
        this._name = name;

        this._asId = StorageANEContext.context.call("createGUID") as String;
        if (isRoot) return;

        var theRet:* = StorageANEContext.context.call("getReference", path, url);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
        if (theRet != null) {
            this._name = theRet["name"];
            this._bucket = theRet["bucket"];
            this._path = theRet["path"];
        } else {
            throw new Error("no StorageReference created");
        }
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        if (StorageANEContext.context) {

            StorageANEContext.listeners.push({"id": _asId, "type": type});
            if (!StorageANEContext.listenersObjects[_asId]) StorageANEContext.listenersObjects[_asId] = this;
            trace("StorageReference addEventListener", type, _asId);
            super.addEventListener(type, listener, useCapture, priority, useWeakReference);
            StorageANEContext.context.call("addEventListener", _asId, type);
        }
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        if (StorageANEContext.context) {
            delete StorageANEContext.listenersObjects[_asId];
            var cnt:int = 0;
            for each (var item:Object in StorageANEContext.listeners) {
                if (item.type == type && item.id == _asId) StorageANEContext.listeners.removeAt(cnt);
                cnt++;
            }
            super.removeEventListener(type, listener, useCapture);
            StorageANEContext.context.call("removeEventListener", _asId, type);
        }

    }

    public function child(path:String):StorageReference {
        var childPath:String = (this.path.lastIndexOf("/") == this.path.length - 1)
                ? this.path + path
                : this.path + "/" + path;
        return new StorageReference(childPath);
    }

    public function get parent():StorageReference {
        if (_parent) return _parent;
        var theRet:* = StorageANEContext.context.call("getParent", _path);
        if (theRet is ANEError) throw theRet as ANEError;
        if (theRet != null) {
            _parent = new StorageReference(theRet["path"], null, theRet["bucket"], theRet["name"], (theRet["path"] == null));
            return _parent;
        }
        return null;
    }

    public function get root():StorageReference {
        if (_root) return _root;
        var theRet:* = StorageANEContext.context.call("getRoot", _path);
        if (theRet is ANEError) throw theRet as ANEError;
        if (theRet != null) {
            _root = new StorageReference(theRet["path"], null, theRet["bucket"], theRet["name"], true);
            return _root;
        }
        return null;
    }

    //aka delete
    public function remove():void {
        if (_path == null) return;
        var theRet:* = StorageANEContext.context.call("deleteReference", _path, _asId);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function getDownloadUrl():void {
        if (_path == null) return;
        var theRet:* = StorageANEContext.context.call("getDownloadUrl", _path, _asId);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function getMetadata():void {
        if (StorageANEContext.context) {
            var theRet:* = StorageANEContext.context.call("getMetadata", _path, _asId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function getFile(destinationFile:File):DownloadTask {
        var downloadTask:DownloadTask = new DownloadTask(_asId);
        if (StorageANEContext.context) {
            StorageANEContext.tasks[downloadTask.asId] = downloadTask;
            var theRet:* = StorageANEContext.context.call("getFile", _path, destinationFile.nativePath, downloadTask.asId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        return downloadTask;
    }

    public function getBytes(maxDownloadSizeBytes:Number = -1):DownloadTask {
        var downloadTask:DownloadTask = new DownloadTask(_asId);
        if (StorageANEContext.context) {
            StorageANEContext.tasks[downloadTask.asId] = downloadTask;
            var theRet:* = StorageANEContext.context.call("getBytes", _path, maxDownloadSizeBytes, downloadTask.asId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        return downloadTask;
    }

    public function putFile(file:File, metadata:StorageMetadata = null):UploadTask {
        if (_path == null || _name == null) return null;
        var uploadTask:UploadTask = new UploadTask(_asId);
        if (StorageANEContext.context) {
            StorageANEContext.tasks[uploadTask.asId] = uploadTask;
            var theRet:* = StorageANEContext.context.call("putFile", _path, uploadTask.asId, file.nativePath, metadata);
            if (theRet is ANEError) throw theRet as ANEError;
        }
        return uploadTask;
    }

    public function putBytes(byteArray:ByteArray, metadata:StorageMetadata = null):UploadTask {
        if (_path == null || _name == null) return null;
        var uploadTask:UploadTask = new UploadTask(_asId);
        StorageANEContext.tasks[uploadTask.asId] = uploadTask;
        var theRet:* = StorageANEContext.context.call("putBytes", _path, uploadTask.asId, byteArray);
        if (theRet is ANEError) throw theRet as ANEError;
        return uploadTask;
    }

    public function updateMetadata(metadata:StorageMetadata):void {
        if (_path == null || _name == null) return;
        var theRet:* = StorageANEContext.context.call("updateMetadata", _path, _asId, metadata);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public function get bucket():String {
        return _bucket;
    }

    public function get name():String {
        return _name;
    }

    public function get path():String {
        return _path;
    }
}
}
