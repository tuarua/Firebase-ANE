/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua.firebase.storage {
import com.tuarua.firebase.StorageANEContext;
import com.tuarua.fre.ANEError;

import flash.filesystem.File;
import flash.utils.ByteArray;

public class StorageReference {
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
    public function remove(listener:Function = null):void {
        if (_path == null) return;
        if (StorageANEContext.context) {
            var eventId:String;
            if (listener) {
                eventId = StorageANEContext.context.call("createGUID") as String;
                StorageANEContext.closures[eventId] = listener;
            }
            var theRet:* = StorageANEContext.context.call("deleteReference", _path, eventId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function getDownloadUrl(listener:Function):void {
        if (_path == null) return;
        if (StorageANEContext.context) {
            var eventId:String = StorageANEContext.context.call("createGUID") as String;
            StorageANEContext.closures[eventId] = listener;
            var theRet:* = StorageANEContext.context.call("getDownloadUrl", _path, eventId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function getMetadata(listener:Function):void {
        if (StorageANEContext.context) {
            var eventId:String = StorageANEContext.context.call("createGUID") as String;
            StorageANEContext.closures[eventId] = listener;
            var theRet:* = StorageANEContext.context.call("getMetadata", _path, eventId);
            if (theRet is ANEError) throw theRet as ANEError;
        }
    }

    public function updateMetadata(metadata:StorageMetadata, listener:Function = null):void {
        if (_path == null || _name == null) return;
        if (StorageANEContext.context) {
            var eventId:String;
            if (listener) {
                eventId = StorageANEContext.context.call("createGUID") as String;
                StorageANEContext.closures[eventId] = listener;
            }
            var theRet:* = StorageANEContext.context.call("updateMetadata", _path, eventId, metadata);
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
