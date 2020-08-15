/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.label {
public class ImageLabeling {
    private static var _imageLabeler:ImageLabeler;

    public static function getClient(options:ImageLabelerOptions = null):ImageLabeler {
        if (_imageLabeler != null) {
            _imageLabeler.reinit(options);
        } else {
            _imageLabeler = new ImageLabeler(options);
        }
        return _imageLabeler;
    }
    /** Disposes the ANE and any Detector ANEs. */
    public static function dispose():void {
        if (ImageLabeler.context) {
            ImageLabeler.dispose();
        }
        _imageLabeler = null;
    }
}
}
