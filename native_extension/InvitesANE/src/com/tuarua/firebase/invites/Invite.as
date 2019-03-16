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
import com.tuarua.firebase.InvitesANEContext;
import com.tuarua.fre.ANEError;

public class Invite {
    /** Sets the title of the navigation bar of the invite dialog.*/
    public var title:String;
    /**<p>Sets the default message to use for the invitation. This is the message that will be sent
     * in the invite, for e.g., via SMS or email. This message must not exceed 100 characters.
     * The message will be modifiable by the user. Maximum length is 100 characters.</p>*/
    public var message:String;
    /**<p>Sets the deepLink for the invitation. |deepLink| is an identifier that your app defines for use
     * across all supported platforms. It will be passed with the invitation to the receiver.
     * You can use it to present customized view when the user receives an invitation in your app.</p>*/
    public var deepLink:String;
    /**<p>Sets an image for invitations. The imageURI is required to be in absolute format. The URI can
     * be either a content URI with extension "jpg" or "png", or a network url with scheme "https".</p> */
    public var customImage:String;
    /**<p>Sets the text shown on the email invitation button to install the app. Default install
     * text used if not set. Maximum length is 32 characters.</p>*/
    public var callToActionText:String;
    /** Sets the HTML-formatted (UTF-8 encoded, no JavaScript) content for invites sent through email. Android only.*/
    public var emailHtmlContent:String;
    /** Sets the subject for invites sent by email. Android only.*/
    public var emailSubject:String;
    /**  App Invite requires defining the client ID if the invite is received on a different platform than iOS. */
    public var otherPlatformClientId:String;
    /**<p>Sets the minimum version of the android app installed on the receiving device. If this
     * minimum version is not installed then the install flow will be triggered.
     * Note that the version code should not be zero.</p>*/
    public var androidMinimumVersionCode:int = 19;
    public function Invite(title:String, message:String) {
        this.title = title;
        this.message = message;
    }
    /** Opens the invite dialog. */
    public function open():void {
        InvitesANEContext.validate();
        var ret:* = InvitesANEContext.context.call("openInvite", this);
        if (ret is ANEError) throw ret as ANEError;
    }

}
}
