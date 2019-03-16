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
 * Configurations for model downloading conditions.
 */
public class ModelDownloadConditions {
    private var _isWiFiRequired:Boolean;
    private var _canDownloadInBackground:Boolean;
    private var _isChargingRequired:Boolean;
    private var _isDeviceIdleRequired:Boolean;

    /**
     * Creates an instance of <code>ModelDownloadConditions</code> with the given conditions.
     *
     * @param isWiFiRequired Whether a device has to be connected to Wi-Fi for downloading to start.
     * @param canDownloadInBackground Whether the model can be downloaded while the app is in the
     *     background.
     * @param isChargingRequired
     * @param isDeviceIdleRequired
     */
    public function ModelDownloadConditions(isWiFiRequired:Boolean, canDownloadInBackground:Boolean = false,
                                            isChargingRequired:Boolean = false, isDeviceIdleRequired:Boolean = false) {
        _isWiFiRequired = isWiFiRequired;
        _canDownloadInBackground = canDownloadInBackground;
        _isChargingRequired = isChargingRequired;
        _isDeviceIdleRequired = isDeviceIdleRequired;
    }

    /**
     * Indicates whether Wi-Fi is required for downloading.
     * @default false
     */
    public function get isWiFiRequired():Boolean {
        return _isWiFiRequired;
    }

    /**
     * Indicates whether the model can be downloaded while the app is in the background. iOS only.
     * @default false
     */
    public function get canDownloadInBackground():Boolean {
        return _canDownloadInBackground;
    }

    /**
     * true if charging is required for download. Android N+ only
     * @default false
     */
    public function get isChargingRequired():Boolean {
        return _isChargingRequired;
    }
    /**
     * true if device idle is required for download. Android N+ only
     * @default false
     */
    public function get isDeviceIdleRequired():Boolean {
        return _isDeviceIdleRequired;
    }
}
}
