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
package com.tuarua.firebase.dynamiclinks {
public final class IosParameters {
    public var bundleId:String;
    /** <p>Your app's App Store ID, used to send users to the App Store when the app isn't installed</p> */
    public var appStoreId:String;
    /** <p>Your app's custom URL scheme, if defined to be something other than your app's bundle ID</p> */
    public var customScheme:String;
    /** <p>The link to open when the app isn't installed. Specify this to do something other than install your
     * app from the App Store when the app isn't installed, such as open the mobile web version of the content,
     * or display a promotional page for your app.</p> */
    public var fallbackUrl:String;
    /** <p>The bundle ID of the iOS app to use on iPads to open the link. The app must be connected to your
     * project from the Overview page of the Firebase console.</p> */
    public var ipadBundleId:String;
    /** <p>The link to open on iPads when the app isn't installed. Specify this to do something other than
     * install your app from the App Store when the app isn't installed, such as open the web version of the
     * content, or display a promotional page for your app.</p> */
    public var ipadFallbackUrl:String;
    /** <p>The version number of the minimum version of your app that can open the link. This flag is passed to
     * your app when it is opened, and your app must decide what to do with it.</p> */
    public var minimumVersion:String;

    public function IosParameters(bundleId:String,
                                  appStoreId:String = null,
                                  customScheme:String = null,
                                  fallbackUrl:String = null,
                                  ipadBundleId:String = null,
                                  ipadFallbackUrl:String = null,
                                  minimumVersion:String = null) {
        this.bundleId = bundleId;
        this.appStoreId = appStoreId;
        this.customScheme = customScheme;
        this.fallbackUrl = fallbackUrl;
        this.ipadBundleId = ipadBundleId;
        this.ipadFallbackUrl = ipadFallbackUrl;
        this.minimumVersion = minimumVersion;
    }
}
}
