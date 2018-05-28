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
[RemoteClass(alias="com.tuarua.firebase.storage.StorageMetadata")]
public final class StorageMetadata {
    /** The name of the bucket containing this object.*/
    public var bucket:String;
    /** Cache-Control directive for the object data.*/
    public var cacheControl:String;
    /** Content-Disposition of the object data.*/
    public var contentDisposition:String;
    /** Content-Encoding of the object data.*/
    public var contentEncoding:String;
    /** Content-Language of the object data.*/
    public var contentLanguage:String;
    /** Content-Type of the object data.*/
    public var contentType:String;
    /** User-provided metadata, in key/value pairs.*/
    public var customMetadata:Object;
    /** The creation time of the object.*/
    public var creationTime:Number;
    /** The modification time of the object metadata.*/
    public var updatedTime:Number;
    /** The content generation of this object. Used for object versioning. */
    public var generation:String;
    /** MD5 hash of the data; encoded using base64.*/
    public var md5Hash:String;
    /**
     * The version of the metadata for this object at this generation. Used
     * for preconditions and for detecting changes in metadata. A metageneration number is only
     * meaningful in the context of a particular generation of a particular object.
     */
    public var metadataGeneration:String;
    /** The name of this object, in gs://bucket/path/to/object.txt, this is object.txt.*/
    public var name:String;
    /** The full path of this object, in gs://bucket/path/to/object.txt, this is path/to/object.txt.*/
    public var path:String;
    /** Content-Length of the data in bytes.*/
    public var size:Number;
}
}