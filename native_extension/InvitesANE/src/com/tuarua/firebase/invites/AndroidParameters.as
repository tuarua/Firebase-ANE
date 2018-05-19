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
package com.tuarua.firebase.invites {
public final class AndroidParameters {
    public var packageName:String;
    /** <p>The link to open when the app isn't installed. Specify this to do something other than install your app
     * from the Play Store when the app isn't installed, such as open the mobile web version of the content, or
     * display a promotional page for your app.</p> */
    public var fallbackUrl:String;
    /** <p>The versionCode of the minimum version of your app that can open the link. If the installed app is an
     * older version, the user is taken to the Play Store to upgrade the app.</p> */
    public var minimumVersion:int = 19;

    public function AndroidParameters(packageName:String = null,
                                      fallbackUrl:String = null,
                                      minimumVersion:int = 0) {
        this.packageName = packageName;
        this.fallbackUrl = fallbackUrl;
        this.minimumVersion = minimumVersion;
    }
}
}
