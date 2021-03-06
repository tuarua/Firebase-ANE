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
import com.tuarua.firebase.ml.common.modeldownload.RemoteModel;
/** A custom model that is stored remotely on the server and downloaded to the device. */
public class CustomRemoteModel extends RemoteModel {
    /**
     * @param name The model name.
     */
    public function CustomRemoteModel(name:String) {
        super(name);
    }
}
}
