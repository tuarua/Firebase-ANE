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
import com.tuarua.firebase.dynamiclinks.DynamicLink;
import com.tuarua.fre.ANEError;

public final class DynamicLinks {
    private static var _shared:DynamicLinks;

    /** @private */
    public function DynamicLinks() {
        if (DynamicLinksANEContext.context) {
            var ret:* = DynamicLinksANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _shared = this;
    }

    /** @private */
    public static function get shared():DynamicLinks {
        if (!_shared) {
            new DynamicLinks();
        }
        return _shared;
    }

    /** Create a long or short Dynamic Link.
     * @param dynamicLink
     * @param listener Optional Function to be called on completion
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(dynamicLinkResult:DynamicLinkResult, error:DynamicLinkError):void {
     *
     * }
     * </listing>
     * @param copyToClipboard
     * @param shorten
     * @param suffix
     */
    public function buildDynamicLink(dynamicLink:DynamicLink, listener:Function, copyToClipboard:Boolean = false,
                                     shorten:Boolean = false, suffix:int = 0):void {
        DynamicLinksANEContext.validate();
        var ret:* = DynamicLinksANEContext.context.call("buildDynamicLink", dynamicLink,
                DynamicLinksANEContext.createCallback(listener), copyToClipboard, shorten, suffix);
        if (ret is ANEError) throw ret as ANEError;
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
        DynamicLinksANEContext.validate();
        var ret:* = DynamicLinksANEContext.context.call("getDynamicLink", DynamicLinksANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (DynamicLinksANEContext.context) {
            DynamicLinksANEContext.dispose();
        }
    }

}
}
