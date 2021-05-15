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
 * Options for GoogleSignIn client.
 */
public class GoogleSignInOptions {
    private var _scopes:Vector.<String>;
    /**
     * Specifies that an ID token for authenticated users is requested.
     * Requesting an ID token requires that the server client ID be specified.
     */
    public var requestIdToken:Boolean = false;
    /**
     * Specifies that offline access is requested.
     * Requesting offline access requires that the server client ID be specified.
     */
    public var requestServerAuthCode:Boolean = false;
    /**
     * The client ID of the server that will need to get `serverAuthCode` or verify `idToken`
     * On Android you can leave that unspecified, then string value of resource `default_web_client_id` will be used.
     */
    public var serverClientId:String;

    public function GoogleSignInOptions(scopes:Vector.<String> = null) {
        _scopes = scopes ? scopes : new <String>[];
    }

    /**
     * Default configuration for Google Sign In.
     */
    public static function get DEFAULT_SIGN_IN():GoogleSignInOptions {
        var options:GoogleSignInOptions = new GoogleSignInOptions(new <String>["openid", "profile"]);
        options.requestIdToken = true;
        return options;
    }

    /**
     * Default and recommended configuration for Play Games Sign In.
     */
    public static function get DEFAULT_GAMES_SIGN_IN():GoogleSignInOptions {
        var options:GoogleSignInOptions = new GoogleSignInOptions(
                new <String>["https://www.googleapis.com/auth/games_lite"]);
        options.requestServerAuthCode = true;
        return options;
    }

    /**
     * Specifies OAuth 2.0 scopes your application requests.
     * You can modify requested scopes using addScope()
     */
    public function get scopes():Vector.<String> {
        return _scopes;
    }

    /**
     * Specifies that user ID is requested by your application.
     * Will add `openid` scope if set to true.
     *
     * @see GoogleSignInAccount#id
     */
    public function get requestId():Boolean {
        return hasScope("openid");
    }

    public function set requestId(value:Boolean):void {
        setScope("openid", value);
    }

    /**
     * Specifies that email info is requested by your application.
     * Will add `email` scope if set to true.
     *
     * @see GoogleSignInAccount#email
     */
    public function get requestEmail():Boolean {
        return hasScope("email");
    }

    public function set requestEmail(value:Boolean):void {
        setScope("email", value);
    }

    /**
     * Specifies that user's profile info is requested by your application.
     * Will add `profile` scope if set to true.
     */
    public function get requestProfile():Boolean {
        return hasScope("profile");
    }

    public function set requestProfile(value:Boolean):void {
        setScope("profile", value);
    }

    /**
     * Add OAuth scope to requested
     *
     * @param scope
     */
    public function addScope(scope:String):void {
        if (!scope) {
            throw new ArgumentError("empty scope");
        }
        setScope(scope, true);
    }

    public function hasScope(scope:String):Boolean {
        return _scopes.indexOf(scope) > -1;
    }

    private function setScope(scope:String, value:Boolean):void {
        var index:int = _scopes.indexOf(scope);
        if (value && index === -1) {
            _scopes.push(scope);
        } else if (!value && index > -1) {
            _scopes.splice(index, 1);
        }
    }
}
}
