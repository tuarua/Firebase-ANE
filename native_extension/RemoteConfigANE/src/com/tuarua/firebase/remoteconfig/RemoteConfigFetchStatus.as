package com.tuarua.firebase.remoteconfig {
public final class RemoteConfigFetchStatus {
    /** Config has never been fetched.*/
    public static const NO_FETCH_YET:uint = 0;
    /** Config fetch succeeded.*/
    public static const SUCCESS:uint = 1;
    /** Config fetch failed.*/
    public static const FAILURE:uint = 2;
    /** Config fetch was throttled.*/
    public static const THROTTLED:uint = 3;
}
}