package com.tuarua.firebase.auth.extensions

import com.google.firebase.FirebaseException
import com.google.firebase.auth.FirebaseAuthException

val FirebaseAuthExceptionMap: Map<String, Int>
    get() = mapOf(
            "ERROR_INVALID_CUSTOM_TOKEN" to 17000,
            "ERROR_CUSTOM_TOKEN_MISMATCH" to 17002,
            "ERROR_INVALID_CREDENTIAL" to 17004,
            "ERROR_USER_DISABLED" to 17005,
            "ERROR_OPERATION_NOT_ALLOWED" to 17006,
            "ERROR_EMAIL_ALREADY_IN_USE" to 17007,
            "ERROR_INVALID_EMAIL" to 17008,
            "ERROR_WRONG_PASSWORD" to 17009,
            "ERROR_TOO_MANY_REQUESTS" to 17010,
            "ERROR_USER_NOT_FOUND" to 17011,
            "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL" to 17012,
            "ERROR_REQUIRES_RECENT_LOGIN" to 17014,
            "ERROR_PROVIDER_ALREADY_LINKED" to 17015,
            "ERROR_NO_SUCH_PROVIDER" to 17016,
            "ERROR_INVALID_USER_TOKEN" to 17017,
            "ERROR_NETWORK_ERROR" to 17020,
            "ERROR_USER_TOKEN_EXPIRED" to 17021,
            "ERROR_INVALID_API_KEY" to 17023,
            "ERROR_USER_MISMATCH" to 17024,
            "ERROR_CREDENTIAL_ALREADY_IN_USE" to 17025,
            "ERROR_WEAK_PASSWORD" to 17026,
            "ERROR_APP_NOT_AUTHORIZED" to 17028,
            "ERROR_EXPIRED_ACTION_CODE" to 17029,
            "ERROR_INVALID_ACTION_CODE" to 17030,
            "ERROR_INVALID_MESSAGE_PAYLOAD" to 17031,
            "ERROR_INVALID_SENDER" to 17032,
            "ERROR_INVALID_RECIPIENT_EMAIL" to 17033,
            "ERROR_MISSING_EMAIL" to 17034,
            "ERROR_MISSING_IOS_BUNDLE_ID" to 17036,
            "ERROR_MISSING_ANDROID_PACKAGE_NAME" to 17037,
            "ERROR_UNAUTHORIZED_DOMAIN" to 17038,
            "ERROR_INVALID_CONTINUE_URI" to 17039,
            "ERROR_MISSING_CONTINUE_URI" to 17040,
            "ERROR_MISSING_PHONE_NUMBER" to 17041,
            "ERROR_INVALID_PHONE_NUMBER" to 17042,
            "ERROR_MISSING_VERIFICATION_CODE" to 17043,
            "ERROR_INVALID_VERIFICATION_CODE" to 17044,
            "ERROR_MISSING_VERIFICATION_ID" to 17045,
            "ERROR_INVALID_VERIFICATION_ID" to 17046,
            "ERROR_MISSING_APP_CREDENTIAL" to 17047,
            "ERROR_INVALID_APP_CREDENTIAL" to 17048,
            "ERROR_SESSION_EXPIRED" to 17051,
            "ERROR_QUOTA_EXCEEDED" to 17052,
            "ERROR_MISSING_APP_TOKEN" to 17053,
            "ERROR_NOTIFICATION_NOT_FORWARDED" to 17054,
            "ERROR_APP_NOT_VERIFIED" to 17055,
            "ERROR_CAPTCHA_CHECK_FAILED" to 17056,
            "ERROR_WEB_CONTEXT_ALREADY_PRESENTED" to 17057,
            "ERROR_WEB_CONTEXT_CANCELLED" to 17058,
            "ERROR_APP_VERIFICATION_USER_INTERACTION_FAILURE" to 17059,
            "ERROR_INVALID_CLIENT_ID" to 17060,
            "ERROR_WEB_NETWORK_REQUEST_FAILED" to 17061,
            "ERROR_WEB_INTERNAL" to 17062,
            "ERROR_NULL_USER" to 17067,
            "ERROR_KEYCHAIN" to 17995,
            "ERROR_INTERNAL" to 17999
    )

fun FirebaseAuthException.toMap(): Map<String, Any?>? {
    return mapOf(
            "text" to message.toString(),
            "id" to FirebaseAuthExceptionMap[errorCode])
}

fun FirebaseException.toMap(): Map<String, Any?>? {
    return mapOf(
            "text" to message.toString(),
            "id" to 0)
}