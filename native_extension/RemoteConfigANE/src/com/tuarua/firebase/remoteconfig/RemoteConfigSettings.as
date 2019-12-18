/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua.firebase.remoteconfig {
[RemoteClass(alias="com.tuarua.firebase.remoteconfig.RemoteConfigSettings")]
public class RemoteConfigSettings {
    /**
     * @deprecated
     * */
    public var developerModeEnabled:Boolean;
    /** Sets the minimum interval between successive fetch calls.*/
    public var minimumFetchInterval:Number = 0;
    /** Sets the connection timeout for fetch requests to the Firebase Remote Config servers in seconds.*/
    public var fetchTimeout:Number = 60;

    public function RemoteConfigSettings(developerModeEnabled:Boolean = false) {
        this.developerModeEnabled = developerModeEnabled;
    }
}
}
