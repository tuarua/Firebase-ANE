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
public final class StorageErrorCodes {
    public static const UNKNOWN:int = -13000;
    public static const OBJECT_NOT_FOUND:int = -13010;
    public static const BUCKET_NOT_FOUND:int = -13011;
    public static const PROJECT_NOT_FOUND:int = -13012;
    public static const QUOTA_EXCEEDED:int = -13013;
    public static const NOT_AUTHENTICATED:int = -13020;
    public static const NOT_AUTHORIZED:int = -13021;
    public static const RETRY_LIMIT_EXCEEDED:int = -13030;
    public static const INVALID_CHECKSUM:int = -13031;
    public static const CANCELED:int = -13040;
}
}
