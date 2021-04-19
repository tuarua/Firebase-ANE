/*
 * Copyright 2021 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.google.signin {

/**
 * GoogleSignIn account information
 */
public class GoogleSignInAccount {

    private var _id:String = null;
    private var _idToken:String = null;
    private var _serverAuthCode:String = null;
    private var _displayName:String = null;
    private var _email:String = null;
    private var _photoUrl:String = null;
    private var _grantedScopes:Vector.<String> = new <String>[];
    private var _familyName:String = null;
    private var _givenName:String = null;
    private var _accessToken:String = null;

    public function GoogleSignInAccount() {
    }

    /**
     * Unique ID for the Google account.
     * Will be present if `openid` scope was granted.
     * Also on iOS platform.
     *
     * @see GoogleSignInOptions#DEFAULT_SIGN_IN
     * @see GoogleSignInOptions#requestId
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getid
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDGoogleUser#userid
     */
    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    /**
     * Returns an ID token that you can send to your server.
     * Will be present if client options requestIdToken is true.
     * Also on iOS platform.
     *
     * @see GoogleSignInOptions#requestIdToken
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getidtoken
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDAuthentication#idtoken
     */
    public function get idToken():String {
        return _idToken;
    }

    public function set idToken(value:String):void {
        _idToken = value;
    }

    /**
     * Returns a one-time server auth code to send to your web server which can be exchanged for access token.
     * Will be present if client options requestServerAuthCode is true.
     *
     * @see GoogleSignInOptions#requestServerAuthCode
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getserverauthcode
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDGoogleUser#serverauthcode
     */
    public function get serverAuthCode():String {
        return _serverAuthCode;
    }

    public function set serverAuthCode(value:String):void {
        _serverAuthCode = value;
    }

    /**
     * Returns the email address of the signed in user.
     * Will be present if `email` scope was granted.
     *
     * @see GoogleSignInOptions#requestEmail
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getemail
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDProfileData#email
     */
    public function get email():String {
        return _email;
    }

    public function set email(value:String):void {
        _email = value;
    }

    /**
     * Returns the photo url of the signed in user.
     * Will be present if user has a profile picture and `profile` scope was granted.
     *
     * @see GoogleSignInOptions#requestProfile
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-uri-getphotourl
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDProfileData#-imageurlwithdimension:
     */
    public function get photoUrl():String {
        return _photoUrl;
    }

    public function set photoUrl(value:String):void {
        _photoUrl = value;
    }

    /**
     * Returns the display name of the signed in user.
     * Will be present if `profile` scope was granted.
     *
     * @see GoogleSignInOptions#requestProfile
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getdisplayname
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDProfileData#name
     */
    public function get displayName():String {
        return _displayName;
    }

    public function set displayName(value:String):void {
        _displayName = value;
    }

    /**
     * Returns the family name of the signed in user.
     * Will be present if `profile` scope was granted.
     *
     * @see GoogleSignInOptions#requestProfile
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getfamilyname
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDProfileData#familyname
     */
    public function get familyName():String {
        return _familyName;
    }

    public function set familyName(value:String):void {
        _familyName = value;
    }

    /**
     * Returns the given name of the signed in user.
     * Will be present if `profile` scope was granted.
     *
     * @see GoogleSignInOptions#requestProfile
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-string-getgivenname
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDProfileData#givenname
     */
    public function get givenName():String {
        return _givenName;
    }

    public function set givenName(value:String):void {
        _givenName = value;
    }

    /**
     * Returns all scopes that have been authorized to your application.
     *
     * @see GoogleSignInOptions#scopes
     * @see https://developers.google.com/android/reference/com/google/android/gms/auth/api/signin/GoogleSignInAccount#public-setscope-getgrantedscopes
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDGoogleUser#grantedscopes
     */
    public function get grantedScopes():Vector.<String> {
        return _grantedScopes;
    }

    public function set grantedScopes(value:Vector.<String>):void {
        _grantedScopes = value;
    }

    /**
     * The OAuth2 access token to access Google services.
     * Will be present on iOS platform.
     *
     * @see https://developers.google.com/identity/sign-in/ios/reference/Classes/GIDAuthentication#accesstoken
     */
    public function get accessToken():String {
        return _accessToken;
    }

    public function set accessToken(value:String):void {
        _accessToken = value;
    }

    public function hasScope(scope:String):Boolean {
        return _grantedScopes.indexOf(scope) !== -1;
    }

}
}
