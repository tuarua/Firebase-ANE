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

package com.tuarua.firebase.auth {
public class AuthCredential {
    private var _provider:String;
    private var _param0:String;
    private var _param1:String;

    public function AuthCredential(provider:String, param0:String = null, param1:String = null) {
        this._provider = provider;
        this._param0 = param0;
        this._param1 = param1;
    }

    public function get provider():String {
        return _provider;
    }

    public function get param0():String {
        return _param0;
    }

    public function get param1():String {
        return _param1;
    }
}
}
