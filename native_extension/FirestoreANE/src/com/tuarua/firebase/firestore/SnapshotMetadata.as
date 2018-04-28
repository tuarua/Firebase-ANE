package com.tuarua.firebase.firestore {
public class SnapshotMetadata {
    public var isFromCache:Boolean;
    public var hasPendingWrites:Boolean;
    public function SnapshotMetadata(isFromCache:Boolean, hasPendingWrites:Boolean) {
        this.isFromCache = isFromCache;
        this.hasPendingWrites = hasPendingWrites;
    }
}
}
