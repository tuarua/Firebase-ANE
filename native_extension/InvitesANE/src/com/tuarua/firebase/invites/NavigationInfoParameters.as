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
public final class NavigationInfoParameters {
    /** <p>If set to true, skip the app preview page when the Dynamic Link is opened, and instead redirect to
     * the app or store. The app preview page (enabled by default) can more reliably send users to the most
     * appropriate destination when they open Dynamic Links in apps; however, if you expect a Dynamic Link
     * to be opened only in apps that can open Dynamic Links reliably without this page, you can disable
     * it with this parameter. Note: the app preview page is only shown on iOS currently, but may eventually
     * be shown on Android. This parameter will affect the behavior of the Dynamic Link on both platforms.</p> */
    public var forcedRedirectEnabled:Boolean;

    public function NavigationInfoParameters(forcedRedirectEnabled:Boolean) {
        this.forcedRedirectEnabled = forcedRedirectEnabled;
    }
}
}
