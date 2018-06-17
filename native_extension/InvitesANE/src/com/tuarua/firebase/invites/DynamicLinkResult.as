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
public final class DynamicLinkResult {
    public var url:String;
    public var invitationId:String;
    /** The value of this key is a String that represents the bundle ID of the
     * app that made the request. iOS only.*/
    public var sourceApplication:String;
    /** The value of this key is a String containing the URL to open. iOS only. */
    public var sourceUrl:String;
    public function DynamicLinkResult() {
    }
}
}