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
import com.tuarua.firebase.ml.custom.ModelInterpreterANEContext;
import com.tuarua.fre.ANEError;
/**
 * A Firebase model manager for both local and cloud models.
 */
public class ModelManager {
    public function ModelManager() {
    }


    // TODO
    public function isModelDownloaded():void {

    }

    /**
     * Registers a cloud model. The model name is unique to each cloud model and can only be registered
     * once with a given instance of the <code>ModelManager</code>. The model name should be the same name used
     * when uploading the model to the Firebase Console. It's OK to separately register a cloud model
     * and a local model with the same name for a given instance of the <code>ModelManager</code>.
     *
     * @param cloudModelSource The cloud model source to register.
     * @return Whether the registration was successful. Returns false if the given <code>cloudModelSource</code> is
     *     invalid or has already been registered.
     */
    public function registerCloudModel(cloudModelSource:CloudModelSource):Boolean {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("registerCloudModel", cloudModelSource);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Registers a local model. The model name is unique to each local model and can only be registered
     * once with a given instance of the <code>ModelManager</code>. It's OK to separately register a cloud model
     * and a local model with the same name for a given instance of the <code>ModelManager</code>.
     *
     * @param localModelSource The local model source to register.
     * @return Whether the registration was successful. Returns false if the given <code>localModelSource</code> is
     *     invalid or has already been registered.
     */
    public function registerLocalModel(localModelSource:LocalModelSource):Boolean {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("registerLocalModel", localModelSource);
        if (ret is ANEError) throw ret as ANEError;
        return ret as Boolean;
    }

    /**
     * Gets the registered cloud model with the given name. Returns <code>null</code> if the model was never
     * registered with this model manager.
     *
     * @param name Name of the cloud model.
     * @return The cloud model that was registered with the given name. Returns null if the model was
     *     never registered with this model manager.
     */
    public function cloudModelSource(name:String):String {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("cloudModelSource", name);
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

    /**
     * Gets the registered local model with the given name. Returns <code>null</code> if the model was never
     * registered with this model manager.
     *
     * @param name Name of the local model.
     * @return The local model that was registered with the given name. Returns null if the model was
     *     never registered with this model manager.
     */
    public function localModelSource(name:String):String {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("localModelSource", name);
        if (ret is ANEError) throw ret as ANEError;
        return ret as String;
    }

}
}
