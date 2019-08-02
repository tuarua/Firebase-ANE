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

package com.tuarua.firebase.ml.common.modeldownload {

/**
 * A model stored in the cloud and downloaded to the device.
 */
public class CloudModelSource {
    private var _name:String;
    private var _enableModelUpdates:Boolean;
    private var _initialConditions:ModelDownloadConditions;
    private var _updateConditions:ModelDownloadConditions;
    /**
     * Creates an instance of <code>CloudModelSource</code> with the given name and the download conditions.
     *
     * @param name The name of the model to download. Specify the name you assigned the model when you
     *     uploaded it to the Firebase console. Within the same Firebase app, all cloud models should
     *     have distinct names.
     * @param enableModelUpdates Indicates whether model updates are enabled.
     * @param initialConditions Initial downloading conditions for the model.
     * @param updateConditions Subsequent update conditions for the model. If it is null and
     *     <code>enableModelUpdates</code> is true, the default download conditions are used.
     */
    public function CloudModelSource(name:String, enableModelUpdates:Boolean,
                                     initialConditions:ModelDownloadConditions,
                                     updateConditions:ModelDownloadConditions = null) {
        _name = name;
        _enableModelUpdates = enableModelUpdates;
        _initialConditions = initialConditions;
        _updateConditions = updateConditions;
    }

    /** The model name. */
    public function get name():String {
        return _name;
    }

    /** Indicates whether model updates are enabled. */
    public function get enableModelUpdates():Boolean {
        return _enableModelUpdates;
    }

    /** Initial downloading conditions for the model. */
    public function get initialConditions():ModelDownloadConditions {
        return _initialConditions;
    }

    /**
     * Subsequent update conditions for the model. If <code>null</code> is passed to the initializer, the default
     * download conditions are set, but are only used if <code>enableModelUpdates</code> is <code>true</code>.
     */
    public function get updateConditions():ModelDownloadConditions {
        return _updateConditions;
    }
}
}