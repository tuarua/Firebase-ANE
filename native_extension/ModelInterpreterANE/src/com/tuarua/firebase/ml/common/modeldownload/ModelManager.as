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
 * A Firebase model manager for both local and cloud models.
 */
public class ModelManager {
    public function ModelManager() {
    }

    // TODO
    public function isModelDownloaded():void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("isModelDownloaded");
        if (ret is ANEError) throw ret as ANEError;
    }

    public function deleteDownloadedModel(model:CustomRemoteModel):void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("deleteDownloadedModel", model);
        if (ret is ANEError) throw ret as ANEError;
    }

    public function download(model:CustomRemoteModel, conditions:ModelDownloadConditions):void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("download", model, conditions);
        if (ret is ANEError) throw ret as ANEError;
    }


}
}
