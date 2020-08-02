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

package com.tuarua.mlkit {
import com.tuarua.fre.ANEError;
import com.tuarua.mlkit.vision.display.CameraOverlay;

import flash.events.EventDispatcher;

public class MLKit extends EventDispatcher {
    private static var _mlkit:MLKit;
    private var _cameraOverlay:CameraOverlay = new CameraOverlay();

    /** @private */
    public function MLKit() {
        if (MLKitANEContext.context) {
            var ret:* = MLKitANEContext.context.call("init");
            if (ret is ANEError) throw ret as ANEError;
        }
        _mlkit = this;
    }


    /** The Vision ANE instance. */
    public static function get mlkit():MLKit {
        if (!_mlkit) {
            new MLKit();
        }
        return _mlkit;
    }

    /** Requests permissions for this ANE. */
    public function requestPermissions():void {
        if (MLKitANEContext.context) {
            var ret:* = MLKitANEContext.context.call("requestPermissions");
            if (ret is ANEError) throw ret as ANEError;
        }
    }

    /** Whether the camera is supported on users version of Android (21 or >). */
    public function get isCameraSupported():Boolean {
        if (MLKitANEContext.context) {
            return MLKitANEContext.context.call("isCameraSupported") as Boolean;
        }
        return false;
    }

    public function get cameraOverlay():CameraOverlay {
        return _cameraOverlay;
    }

    /** Disposes the ANE and any Detector ANEs. */
    public static function dispose():void {
        if (MLKitANEContext.context) {
            MLKitANEContext.dispose();
        }
    }

}
}
