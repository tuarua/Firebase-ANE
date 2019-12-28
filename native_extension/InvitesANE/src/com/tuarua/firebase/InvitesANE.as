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
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public final class InvitesANE extends EventDispatcher {
    private static var _invites:InvitesANE;

    /** @private */
    public function InvitesANE() {
        if (InvitesANEContext.context) {
            var ret:* = InvitesANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _invites = this;
    }

    /** Determine if the app has a pending dynamic link and provide access to the dynamic link parameters.
     * @param listener Optional Function to be called on completion
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(dynamicLinkResult:DynamicLinkResult, error:DynamicLinkError):void {
     *
     * }
     * </listing>
     */
    public function getDynamicLink(listener:Function):void {
        InvitesANEContext.validate();
        var ret:* = InvitesANEContext.context.call("getDynamicLink", InvitesANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** The ANE instance. */
    public static function get invites():InvitesANE {
        if (!_invites) {
            new InvitesANE();
        }
        return _invites;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (InvitesANEContext.context) {
            InvitesANEContext.dispose();
        }
    }

}
}
