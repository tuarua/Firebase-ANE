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

package com.tuarua.firebase.modelInterpreter {
/**
 * A model stored locally on the device.
 */
public class LocalModelSource {
    private var _path:String;
    private var _name:String;

    /**
     * Creates an instance of `LocalModelSource` with a given name and file path.
     *
     * @param name A local model name. Within the same Firebase app, all local models should have distinct names.
     * @param path An relative path to the model file stored locally on the device.
     */
    public function LocalModelSource(name:String, path:String) {
        _name = name;
        _path = path;
    }

    /** The file path to the model stored locally on the device. */
    public function get path():String {
        return _path;
    }

    /** The model name. */
    public function get name():String {
        return _name;
    }
}
}