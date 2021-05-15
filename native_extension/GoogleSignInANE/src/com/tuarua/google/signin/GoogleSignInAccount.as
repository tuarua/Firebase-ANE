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
    /**
     * Unique ID for the Google account.
     * Will be present if `openid` scope was granted.
     */
    public var id:String;
    /**
     * Returns an ID token that you can send to your server.
     * Will be present if client options requestIdToken is true.
     */
    public var idToken:String;
    /**
     * Returns a one-time server auth code to send to your web server which can be exchanged for access token.
     * Will be present if client options requestServerAuthCode is true.
     */
    public var serverAuthCode:String;
    /**
     * Returns the display name of the signed in user.
     * Will be present if `profile` scope was granted.
     */
    public var displayName:String;
    /**
     * Returns the email address of the signed in user.
     * Will be present if `email` scope was granted.
     */
    public var email:String;
    /**
     * Returns the photo url of the signed in user.
     * Will be present if user has a profile picture and `profile` scope was granted.
     */
    public var photoUrl:String;
    /**
     * Returns all scopes that have been authorized to your application.
     */
    public var grantedScopes:Array = [];
    /**
     * Returns the family name of the signed in user.
     * Will be present if `profile` scope was granted.
     */
    public var familyName:String;
    /**
     * Returns the given name of the signed in user.
     * Will be present if `profile` scope was granted.
     */
    public var givenName:String;
    /**
     * The OAuth2 access token to access Google services.
     * iOS only.
     */
    public var accessToken:String;

    public function GoogleSignInAccount() {
    }

    public function hasScope(scope:String):Boolean {
        return grantedScopes.indexOf(scope) > -1;
    }
}
}
