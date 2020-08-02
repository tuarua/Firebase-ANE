/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.firebase.auth {
public class OAuthProvider {
    private var _providerId:String;
    private var _customParameters:Object;
    private var _scopes:Vector.<String> = new Vector.<String>();

    public function OAuthProvider(providerId:String) {
        this._providerId = providerId;
    }

//    public function credential(providerId:String, idToken:String, accessToken:String):OAuthCredential {
//        return null;
//    }

    public function get providerId():String {
        return _providerId;
    }

    public function get customParameters():Object {
        return _customParameters;
    }

    public function set customParameters(value:Object):void {
        _customParameters = value;
    }

    public function get scopes():Vector.<String> {
        return _scopes;
    }

    public function set scopes(value:Vector.<String>):void {
        _scopes = value;
    }
}
}
