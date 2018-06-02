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

    /**
     * Creates a StorageReference initialized at a child Firebase Storage location.
     * for instance "path/to/object".
     *
     * @param path A relative path from the root to initialize the reference with
     * @param url A gs:// or https:// URL to initialize the reference with.
     * @param bucket
     * @param name
     * @param isRoot
     */
    public function StorageReference(path:String = null, url:String = null, bucket:String = null, name:String = null,
                                     isRoot:Boolean = false) {
        StorageANEContext.validate();
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

    /**
     * Creates a new StorageReference pointing to a child object of the current reference.
     *   path = foo      child = bar    newPath = foo/bar
     *   path = foo/bar  child = baz    newPath = foo/bar/baz
     * All leading and trailing slashes will be removed, and consecutive slashes will be
     * compressed to single slashes. For example:
     *   child = /foo/bar     newPath = foo/bar
     *   child = foo/bar/     newPath = foo/bar
     *   child = foo///bar    newPath = foo/bar
     * @param path Path to append to the current path.
     * @return A new StorageReference pointing to a child location of the current reference.
     */
    public function child(path:String):StorageReference {
        var childPath:String = (this.path.lastIndexOf("/") == this.path.length - 1)
                ? this.path + path
                : this.path + "/" + path;
        return new StorageReference(childPath);
    }

    /**
     * Creates a new StorageReference pointing to the parent of the current reference
     * or nil if this instance references the root location.
     * For example:
     *   path = foo/bar/baz   parent = foo/bar
     *   path = foo           parent = (root)
     *   path = (root)        parent = nil
     * @return A new StorageReference pointing to the parent of the current reference.
     */
    public function get parent():StorageReference {
        if (_parent) return _parent;
        StorageANEContext.validate();
        var theRet:* = StorageANEContext.context.call("getParent", _path);
        if (theRet is ANEError) throw theRet as ANEError;
        if (theRet != null) {
            _parent = new StorageReference(theRet["path"], null, theRet["bucket"], theRet["name"], (theRet["path"] == null));
            return _parent;
        }
        return null;
    }

    /**
     * Creates a new StorageReference pointing to the root object.
     * @return A new StorageReference pointing to the root object.
     */
    public function get root():StorageReference {
        if (_root) return _root;
        StorageANEContext.validate();
        var theRet:* = StorageANEContext.context.call("getRoot", _path);
        if (theRet is ANEError) throw theRet as ANEError;
        if (theRet != null) {
            _root = new StorageReference(theRet["path"], null, theRet["bucket"], theRet["name"], true);
            return _root;
        }
        return null;
    }

    /**
     * Deletes the object at the current path.
     * @param listener Optional
     */
    public function remove(listener:Function = null):void {
        if (_path == null) return;
        StorageANEContext.validate();
        var theRet:* = StorageANEContext.context.call("deleteReference", _path, StorageANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Asynchronously retrieves a long lived download URL with a revokable token.
     * This can be used to share the file with others, but can be revoked by a developer
     * in the Firebase Console if desired.
     *
     * @param listener Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(url:String, error:StorageError):void {
     *
     * }
     * </listing>
     */
    public function getDownloadUrl(listener:Function):void {
        if (_path == null) return;
        StorageANEContext.validate();
        var theRet:* = StorageANEContext.context.call("getDownloadUrl", _path, StorageANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Retrieves metadata associated with an object at the current path.
     *
     * @param listener Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(metadata:StorageMetadata, error:StorageError):void {
     *
     * }
     * </listing>
     */
    public function getMetadata(listener:Function):void {
        StorageANEContext.validate();
        var theRet:* = StorageANEContext.context.call("getMetadata", _path, StorageANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Updates the metadata associated with an object at the current path.
     * @param metadata An StorageMetadata object with the metadata to update.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:StorageError):void {
     *
     * }
     * </listing>
     */
    public function updateMetadata(metadata:StorageMetadata, listener:Function = null):void {
        if (_path == null || _name == null) return;
        StorageANEContext.validate();
        var theRet:* = StorageANEContext.context.call("updateMetadata", _path, StorageANEContext.createEventId(listener), metadata);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /**
     * Asynchronously downloads the object at the current path to a specified system filepath.
     * @param destinationFile A File representing the path the object should be downloaded to.
     *
     * @return An DownloadTask that can be used to monitor or manage the download.
     */
    public function getFile(destinationFile:File):DownloadTask {
        var downloadTask:DownloadTask = new DownloadTask(_asId);
        StorageANEContext.validate();
        StorageANEContext.tasks[downloadTask.asId] = downloadTask;
        var theRet:* = StorageANEContext.context.call("getFile", _path, destinationFile.nativePath, downloadTask.asId);
        if (theRet is ANEError) throw theRet as ANEError;
        return downloadTask;
    }

    /**
     * Asynchronously downloads the object at the StorageReference to a ByteArray in memory.
     * A ByteArray of the provided max size will be allocated, so ensure that the device has enough free
     * memory to complete the download. For downloading large files, getFile may be a better option.
     *
     * @return A DownloadTask that can be used to monitor or manage the download.
     * @param maxDownloadSizeBytes The maximum size in bytes to download. If the download exceeds this size
     * the task will be cancelled and an error will be returned.
     */
    public function getBytes(maxDownloadSizeBytes:Number = -1):DownloadTask {
        var downloadTask:DownloadTask = new DownloadTask(_asId);
        StorageANEContext.validate();
        StorageANEContext.tasks[downloadTask.asId] = downloadTask;
        var theRet:* = StorageANEContext.context.call("getBytes", _path, maxDownloadSizeBytes, downloadTask.asId);
        if (theRet is ANEError) throw theRet as ANEError;
        return downloadTask;
    }

    /**
     * Asynchronously uploads a file to the currently specified FIRStorageReference.
     * @param file A File to be uploaded.
     * @param metadata Optional StorageMetadata containing additional information (MIME type, etc.)
     * about the object being uploaded.
     * @return An instance of UploadTask, which can be used to monitor or manage the upload.
     */
    public function putFile(file:File, metadata:StorageMetadata = null):UploadTask {
        if (_path == null || _name == null) return null;
        var uploadTask:UploadTask = new UploadTask(_asId);
        StorageANEContext.validate();
        StorageANEContext.tasks[uploadTask.asId] = uploadTask;
        var theRet:* = StorageANEContext.context.call("putFile", _path, uploadTask.asId, file.nativePath, metadata);
        if (theRet is ANEError) throw theRet as ANEError;
        return uploadTask;
    }

    /**
     * Asynchronously uploads data to the currently specified FIRStorageReference.
     * This is not recommended for large files, and one should instead upload a file from disk.
     * @param byteArray The ByteArray to upload.
     * @param metadata Optional StorageMetadata containing additional information (MIME type, etc.)
     * about the object being uploaded.
     * @return An instance of UploadTask, which can be used to monitor or manage the upload.
     */
    public function putBytes(byteArray:ByteArray, metadata:StorageMetadata = null):UploadTask {
        if (_path == null || _name == null) return null;
        StorageANEContext.validate();
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
