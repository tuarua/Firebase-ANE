/*
 * Copyright 2018 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.firebase.vision.display {
import com.tuarua.firebase.VisionANEContext;

public class CameraOverlay {
    private var _contentScaleFactor:Number = 1.0;

    public function CameraOverlay() {
    }

    public function addChild(nativeDisplayObject:NativeDisplayObject):void {
        if (nativeDisplayObject.isAdded) return;
        if (VisionANEContext.context == null) return;
        try {
            VisionANEContext.context.call("addNativeChild", nativeDisplayObject, _contentScaleFactor);
            nativeDisplayObject.isAdded = true;
        } catch (e:Error) {
            trace(e.message);
        }
    }

    public function removeChild(nativeDisplayObject:NativeDisplayObject):void {
        if (VisionANEContext.context == null) return;
        try {
            VisionANEContext.context.call("removeNativeChild", nativeDisplayObject.id);
            nativeDisplayObject.isAdded = false;
        } catch (e:Error) {
            trace(e.message);
        }
    }

    public function set contentScaleFactor(value:Number):void {
        _contentScaleFactor = value;
    }

}
}
