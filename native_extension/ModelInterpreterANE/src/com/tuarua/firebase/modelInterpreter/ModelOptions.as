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
 * Options for specifying a custom model.
 */
public class ModelOptions {
    private var _cloudModelName:String;
    private var _localModelName:String;

    /**
     * Creates a new instance of <code>ModelOptions</code> with the given cloud and/or local model name. At least
     * one model name must be provided. If both cloud and local model names are provided, then the cloud
     * model takes priority.
     *
     * @param cloudModelName The cloud custom model name. Pass <code>null</code> if only the provided local model
     *     name should be used.
     * @param localModelName The local custom model name. Pass <code>null</code> if only the provided cloud model
     *     name should be used.
     */
    public function ModelOptions(cloudModelName:String = null, localModelName:String = null) {
        if(cloudModelName == null && localModelName == null) {
            throw new ArgumentError("pass either cloudModelName or localModelName");
        }
        _cloudModelName = cloudModelName;
        _localModelName = localModelName;
    }

    /** The name of a model downloaded from the cloud. */
    public function get cloudModelName():String {
        return _cloudModelName;
    }

    /** The name of a model stored locally on the device. */
    public function get localModelName():String {
        return _localModelName;
    }
}
}