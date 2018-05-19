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
public final class DynamicLink {
    /** <p>The link your app will open. You can specify a URL that your app can handle, typically an app's
     * content/payload, which can initiate app-specific logic (such as crediting the user with a coupon or
     * displaying a welcome screen). This link must be a well-formatted URL, be properly URL-encoded, use
     * either HTTP or HTTPS, and cannot be another Dynamic Link.</p> */
    public var link:String;
    /** <p>Your Dynamic Link domain, which you can find in the Firebase console. A Dynamic Link domain looks
     * like the following example: abc123.app.goo.gl</p> */
    public var dynamicLinkDomain:String;
    public var iosParameters:IosParameters;
    public var androidParameters:AndroidParameters = new AndroidParameters();
    public var googleAnalyticsParameters:GoogleAnalyticsParameters;
    public var itunesConnectAnalyticsParameters:ItunesConnectAnalyticsParameters;
    public var socialMetaTagParameters:SocialMetaTagParameters;
    public var navigationInfoParameters:NavigationInfoParameters;

    public function DynamicLink(link:String, dynamicLinkDomain:String) {
        this.link = link;
        this.dynamicLinkDomain = dynamicLinkDomain;
    }
}
}
