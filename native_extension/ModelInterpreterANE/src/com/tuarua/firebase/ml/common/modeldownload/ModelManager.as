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
import com.tuarua.firebase.ml.custom.CustomRemoteModel;
import com.tuarua.firebase.ml.custom.ModelInterpreterANEContext;
import com.tuarua.fre.ANEError;

/**
 * Manages models that are used by MLKit features.
 */
public class ModelManager {
    public function ModelManager() {
    }
    /** Checks whether the given model has been downloaded.
     * @param remoteModel The model to check the download status for.
     * @param listener
     */
    public function isModelDownloaded(remoteModel:RemoteModel, listener:Function):void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("isModelDownloaded",
                remoteModel, ModelInterpreterANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Deletes the downloaded model from the device.
     * @param model The downloaded model to delete.
     * @param listener
     */
    public function deleteDownloadedModel(model:CustomRemoteModel, listener:Function):void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("deleteDownloadedModel",
                model, ModelInterpreterANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Downloads the given model from the server to a local directory on the device.
     * Use <pre>isModelDownloaded()</pre> to check the download status for the model. If this method is invoked and the model
     * has already been downloaded, a request is made to check if a newer version of the model is available
     * for download. If available, the new version of the model is downloaded.
     * @param model The model to download.
     * @param conditions The conditions for downloading the model.
     * @param listener
     */
    public function download(model:CustomRemoteModel, conditions:ModelDownloadConditions, listener:Function):void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("download", model,
                conditions, ModelInterpreterANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }


}
}
