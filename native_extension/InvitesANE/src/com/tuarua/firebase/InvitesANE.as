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
package com.tuarua.firebase {
import com.tuarua.firebase.invites.DynamicLink;
import com.tuarua.firebase.invites.InviteOptions;
import com.tuarua.fre.ANEError;

public final class InvitesANE {
    private static var _invites:InvitesANE;

    /** @private */
    public function InvitesANE() {
        if (InvitesANEContext.context) {
            var theRet:* = InvitesANEContext.context.call("init");
            if (theRet is ANEError) throw theRet as ANEError;
        }
        _invites = this;
    }

    /** The ANE instance. */
    public static function get invites():InvitesANE {
        if (!_invites) {
            new InvitesANE();
        }
        return _invites;
    }

    /** Create a long or short Dynamic Link.
     * @param dynamicLink
     * @param listener
     * @param shorten
     * @param suffix
     */
    public function buildDynamicLink(dynamicLink:DynamicLink, listener:Function, shorten:Boolean = false,
                                     suffix:int = 0):void {
        InvitesANEContext.validate();
        var theRet:* = InvitesANEContext.context.call("buildDynamicLink", dynamicLink,
                InvitesANEContext.createEventId(listener), shorten, suffix);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** Create a long or short Dynamic Link.
     * @param options
     */
    public function sendInvite(options:InviteOptions):void {
        InvitesANEContext.validate();
        var theRet:* = InvitesANEContext.context.call("sendInvite", options);
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** Determine if the app has a pending dynamic link and provide access to the dynamic link parameters.
     * @param listener
     */
    public function getDynamicLink(listener:Function):void {
        InvitesANEContext.validate();
        var theRet:* = InvitesANEContext.context.call("getDynamicLink",InvitesANEContext.createEventId(listener));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (InvitesANEContext.context) {
            InvitesANEContext.dispose();
        }
    }

}
}
