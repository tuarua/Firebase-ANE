/*
 * Copyright 2019 Tua Rua Ltd.
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

package com.tuarua.firebase.ml.custom {
/** A model stored locally on the device. */
public class LocalModel {
    private var _path:String;
    /**
     * Creates a new instance with the given model file path.
     *
     * @param path An absolute path to the TensorFlow Lite model file stored locally on the device.
     */
    public function LocalModel(path:String) {
        this._path = path;
    }

    /** An absolute path to a model file stored locally on the device. */
    public function get path():String {
        return _path;
    }
}
}
