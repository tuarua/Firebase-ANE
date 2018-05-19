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
public final class GoogleAnalyticsParameters {
    /** <p>Google Play analytics parameters. These parameters (utm_source, utm_medium, utm_campaign, utm_term,
     * utm_content) are passed on to the Play Store as well as appended to the link payload.</p> */
    public var campaign:String;
    /** <p>Google Play analytics parameters. These parameters (utm_source, utm_medium, utm_campaign, utm_term,
     * utm_content) are passed on to the Play Store as well as appended to the link payload.</p> */
    public var content:String;
    /** <p>Google Play analytics parameters. These parameters (utm_source, utm_medium, utm_campaign, utm_term,
     * utm_content) are passed on to the Play Store as well as appended to the link payload.</p> */
    public var medium:String;
    /** <p>Google Play analytics parameters. These parameters (utm_source, utm_medium, utm_campaign, utm_term,
     * utm_content) are passed on to the Play Store as well as appended to the link payload.</p> */
    public var source:String;
    /** <p>Google Play analytics parameters. These parameters (utm_source, utm_medium, utm_campaign, utm_term,
     * utm_content) are passed on to the Play Store as well as appended to the link payload.</p> */
    public var term:String;

    public function GoogleAnalyticsParameters(campaign:String = null,
                                              content:String = null,
                                              medium:String = null,
                                              source:String = null,
                                              term:String = null) {
        this.campaign = campaign;
        this.content = content;
        this.medium = medium;
        this.source = source;
        this.term = term;

    }
}
}
