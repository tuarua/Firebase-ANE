package com.tuarua.google.signin {
public final class GoogleSignInStatusCode {
    /** The sign in was cancelled by the user. */
    public static const SIGN_IN_CANCELLED:int = 12501;
    /** A sign in process is currently in progress and the current one cannot continue.*/
    public static const SIGN_IN_CURRENTLY_IN_PROGRESS:int = 12502;
    /** The sign in attempt didn't succeed with the current account. */
    public static const SIGN_IN_FAILED:int = 12500;
    /** The client attempted to connect to the service but the user is not signed in.*/
    public static const SIGN_IN_REQUIRED:int = 4;
    /** The client attempted to connect to the service with an invalid account name specified.*/
    public static const INVALID_ACCOUNT:int = 5;
    /** Completing the operation requires some form of resolution.*/
    public static const RESOLUTION_REQUIRED:int = 6;
    /** A network error occurred.*/
    public static const NETWORK_ERROR:int = 7;
    /** An internal error occurred.*/
    public static const INTERNAL_ERROR:int = 8;
    /** The application is misconfigured.*/
    public static const DEVELOPER_ERROR:int = 10;
    /** The operation failed with no more detailed information.*/
    public static const ERROR:int = 13;
    /** A blocking call was interrupted while waiting and did not run to completion.*/
    public static const INTERRUPTED:int = 14;
    /** Timed out while awaiting the result.*/
    public static const TIMEOUT:int = 15;
    /** The result was canceled either due to client disconnect*/
    public static const CANCELED:int = 16;
    /** The client attempted to call a method from an API that failed to connect. */
    public static const API_NOT_CONNECTED:int = 17;
}
}
