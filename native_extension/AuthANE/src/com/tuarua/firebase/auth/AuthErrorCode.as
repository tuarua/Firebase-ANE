package com.tuarua.firebase.auth {
// https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Enums/AuthErrorCode
public final class AuthErrorCode {
    /** Indicates a validation error with the custom token. */
    public static const INVALID_CUSTOM_TOKEN:int = 17000;
    /** Indicates the service account and the API key belong to different projects. */
    public static const CUSTOM_TOKEN_MISMATCH:int = 17002;
    /** Indicates the IDP token or requestUri is invalid. */
    public static const INVALID_CREDENTIAL:int = 17004;
    /** Indicates the user’s account is disabled on the server. */
    public static const USER_DISABLED:int = 17005;
    /** Indicates the administrator disabled sign in with the specified identity provider. */
    public static const OPERATION_NOT_ALLOWED:int = 17006;
    /** Indicates the email used to attempt a sign up is already in use. */
    public static const ALREADY_IN_USE:int = 17007;
    /** Indicates the email is invalid. */
    public static const INVALID_EMAIL:int = 17008;
    /** Indicates the user attempted sign in with a wrong password. */
    public static const WRONG_PASSWORD:int = 17009;
    /** Indicates that too many requests were made to a server method. */
    public static const TOO_MANY_REQUESTS:int = 17010;
    /** Indicates the user account was not found. */
    public static const USER_NOT_FOUND:int = 17011;
    /** Indicates account linking is required. */
    public static const ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL:int = 17012;
    /** Indicates the user has attemped to change email or password more than 5 minutes after signing in. */
    public static const REQUIRES_RECENT_LOGIN:int = 17014;
    /** Indicates an attempt to link a provider to which the account is already linked. */
    public static const PROVIDER_ALREADY_LINKED:int = 17015;
    /** Indicates an attempt to unlink a provider that is not linked. */
    public static const NO_SUCH_PROVIDER:int = 17016;
    /** Indicates user’s saved auth credential is invalid, the user needs to sign in again. */
    public static const INVALID_USER_TOKEN:int = 17017;
    /** Indicates a network error occurred (such as a timeout, interrupted connection, or unreachable host).
     * These types of errors are often recoverable with a retry. */
    public static const NETWORK_ERROR:int = 17020;
    /** Indicates the saved token has expired, for example, the user may have changed account password on
     * another device. The user needs to sign in again on the device that made this request. */
    public static const USER_TOKEN_EXPIRED:int = 17021;
    /** Indicates an invalid API key was supplied in the request. */
    public static const INVALID_API_KEY:int = 17023;
    /** Indicates that an attempt was made to reauthenticate with a user which is not the current user. */
    public static const USER_MISMATCH:int = 17024;
    /** Indicates an attempt to link with a credential that has already been linked with a different Firebase account */
    public static const CREDENTIAL_ALREADY_IN_USE:int = 17025;
    /** Indicates an attempt to set a password that is considered too weak. */
    public static const WEAK_PASSWORD:int = 17026;
    /** Indicates the App is not authorized to use Firebase Authentication with the provided API Key. */
    public static const APP_NOT_AUTHORIZED:int = 17028;
    /** Indicates the OOB code is expired. */
    public static const EXPIRED_ACTION_CODE:int = 17029;
    /** Indicates the OOB code is invalid. */
    public static const INVALID_ACTION_CODE:int = 17030;
    /** Indicates that there are invalid parameters in the payload during a send password reset * email attempt. */
    public static const INVALID_MESSAGE_PAYLOAD:int = 17031;
    /** Indicates that the sender email is invalid during a send password reset email attempt. */
    public static const INVALID_SENDER:int = 17032;
    /** Indicates that the recipient email is invalid. */
    public static const INVALID_RECIPIENT_EMAIL:int = 17033;
    /** Indicates that an email address was expected but one was not provided. */
    public static const MISSING_EMAIL:int = 17034;
    /** Indicates that the iOS bundle ID is missing when a iOS App Store ID is provided. */
    public static const MISSING_IOS_BUNDLE_ID:int = 17036;
    /** Indicates that the android package name is missing when the androidInstallApp flag is set to true. */
    public static const MISSING_ANDROID_PACKAGE_NAME:int = 17037;
    /** Indicates that the domain specified in the continue URL is not whitelisted in the Firebase console. */
    public static const UNAUTHORIZED_DOMAIN:int = 17038;
    /** Indicates that the domain specified in the continue URI is not valid. */
    public static const INVALID_CONTINUE_URI:int = 17039;
    /** Indicates that a continue URI was not provided in a request to the backend which requires one. */
    public static const MISSING_CONTINUE_URI:int = 17040;
    /** Indicates that a phone number was not provided in a call to verifyPhoneNumber:completion:. */
    public static const MISSING_PHONE_NUMBER:int = 17041;
    /** Indicates that an invalid phone number was provided in a call to verifyPhoneNumber:completion:. */
    public static const INVALID_PHONE_NUMBER:int = 17042;
    /** Indicates that the phone auth credential was created with an empty verification code. */
    public static const MISSING_VERIFICATION_CODE:int = 17043;
    /** Indicates that an invalid verification code was used in the verifyPhoneNumber request. */
    public static const INVALID_VERIFICATION_CODE:int = 17044;
    /** Indicates that the phone auth credential was created with an empty verification ID. */
    public static const MISSING_VERIFICATION_ID:int = 17045;
    /** Indicates that an invalid verification ID was used in the verifyPhoneNumber request. */
    public static const INVALID_VERIFICATION_ID:int = 17046;
    /** Indicates that the APNS device token is missing in the verifyClient request. */
    public static const MISSING_APP_CREDENTIAL:int = 17047;
    /** Indicates that an invalid APNS device token was used in the verifyClient request. */
    public static const INVALID_APP_CREDENTIAL:int = 17048;
    /** Indicates that the SMS code has expired. */
    public static const SESSION_EXPIRED:int = 17051;
    /** Indicates that the quota of SMS messages for a given project has been exceeded. */
    public static const QUOTA_EXCEEDED:int = 17052;
    /** Indicates that the APNs device token could not be obtained. The app may not have set up remote notification
     * correctly, or may fail to forward the APNs device token to FIRAuth if app delegate swizzling is disabled. */
    public static const MISSING_APP_TOKEN:int = 17053;
    /** Indicates that the app fails to forward remote notification to FIRAuth. */
    public static const NOTIFICATION_NOT_FORWARDED:int = 17054;
    /** Indicates that the app could not be verified by Firebase during phone number authentication. */
    public static const APP_NOT_VERIFIED:int = 17055;
    /** Indicates that the reCAPTCHA token is not valid. */
    public static const CAPTCHA_CHECK_FAILED:int = 17056;
    /** Indicates that an attempt was made to present a new web context while one was already being presented. */
    public static const WEB_CONTEXT_ALREADY_PRESENTED:int = 17057;
    /** Indicates that the URL presentation was cancelled prematurely by the user. */
    public static const WEB_CONTEXT_CANCELLED:int = 17058;
    /** Indicates a general failure during the app verification flow. */
    public static const APP_VERIFICATION_USER_INTERACTION_FAILURE:int = 17059;
    /** Indicates that the clientID used to invoke a web flow is invalid. */
    public static const INVALID_CLIENT_ID:int = 17060;
    /** Indicates that a network request within a SFSafariViewController or UIWebview failed. */
    public static const WEB_NETWORK_REQUEST_FAILED:int = 17061;
    /** Indicates that an internal error occurred within a SFSafariViewController or UIWebview. */
    public static const WEB_INTERNAL:int = 17062;
    /** Indicates that a non-null user was expected as an argmument to the operation but a null user was provided. */
    public static const NULL_USER:int = 17067;
    /** Indicates an error occurred while attempting to access the keychain. */
    public static const KEYCHAIN:int = 17995;
    /** Indicates an internal error occurred. */
    public static const INTERNAL:int = 17999;

}
}
