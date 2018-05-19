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
public final class ItunesConnectAnalyticsParameters {
    /** <p>iTunes Connect analytics parameters. These parameters (pt, at, ct) are passed to the App Store.</p> */
    public var affiliateToken:String;
    /** <p>iTunes Connect analytics parameters. These parameters (pt, at, ct) are passed to the App Store.</p> */
    public var campaignToken:String;
    /** <p>iTunes Connect analytics parameters. These parameters (pt, at, ct) are passed to the App Store.</p> */
    public var providerToken:String;

    public function ItunesConnectAnalyticsParameters(affiliateToken:String = null,
                                                     campaignToken:String = null,
                                                     providerToken:String = null) {
        this.affiliateToken = affiliateToken;
        this.campaignToken = campaignToken;
        this.providerToken = providerToken;
    }
}
}
