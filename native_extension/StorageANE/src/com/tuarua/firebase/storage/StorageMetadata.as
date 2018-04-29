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
    public var bucket:String;
    public var cacheControl:String;
    public var contentDisposition:String;
    public var contentEncoding:String;
    public var contentLanguage:String;
    public var contentType:String;
    public var customMetadata:Object;
    public var creationTime:Number;
    public var updatedTime:Number;
    public var generation:String;
    public var md5Hash:String;
    public var metadataGeneration:String;
    public var name:String;
    public var path:String;
    public var size:Number;
}
}