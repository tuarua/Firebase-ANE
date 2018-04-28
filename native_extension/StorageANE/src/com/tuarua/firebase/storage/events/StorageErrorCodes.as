package com.tuarua.firebase.storage.events {
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
