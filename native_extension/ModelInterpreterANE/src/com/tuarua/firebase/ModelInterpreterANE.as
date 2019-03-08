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

package com.tuarua.firebase {
import com.tuarua.firebase.modelInterpreter.ModelInputOutputOptions;
import com.tuarua.firebase.modelInterpreter.ModelInputs;
import com.tuarua.firebase.modelInterpreter.ModelOptions;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public class ModelInterpreterANE extends EventDispatcher {
    private static var _modelInterpreter:ModelInterpreterANE;
    private static var _modelManager:ModelManager = new ModelManager();
    private var options:ModelOptions;
    private static var _isStatsCollectionEnabled:Boolean = true;
    public function ModelInterpreterANE(options: ModelOptions) {
        this.options = options;
        if (ModelInterpreterANEContext.context) {
            var ret:* = ModelInterpreterANEContext.context.call("init", options, _isStatsCollectionEnabled);
            if (ret is ANEError) throw ret as ANEError;
        }
        _modelInterpreter = this;
    }

    /**
     * Runs model inference with the given inputs and data options asynchronously. Inputs and data
     * options should remain unchanged until the model inference completes.
     *
     * @param inputs Inputs for custom model inference.
     * @param options Data options for the custom model specifiying input and output data types and
     *     dimensions.
     * @param listener Handler to call back on the main thread with <code>ModelOutputs</code> or error.
     * @param numPossibilities The number of possibile values that may match.
     * @param maxResults The number of results to return.
     */
    public function run(inputs: ModelInputs, options: ModelInputOutputOptions, listener:Function, numPossibilities:uint, maxResults:int = 5):void {
        ModelInterpreterANEContext.validate();
        var ret:* = ModelInterpreterANEContext.context.call("run", inputs, options,
                maxResults, numPossibilities, ModelInterpreterANEContext.createEventId(listener));
        if (ret is ANEError) throw ret as ANEError;
    }
    /**
     * A Firebase interpreter for a custom model.
     */
    public static function modelInterpreter(options: ModelOptions):ModelInterpreterANE {
        if (!_modelInterpreter) {
            new ModelInterpreterANE(options);
        }
        return _modelInterpreter;
    }

    /**
     * Gets the model manager for the default Firebase app. The default Firebase app instance must be
     * configured before calling this method; otherwise raises an exception. The
     * returned model manager is thread safe. Models hosted in non-default Firebase apps are currently
     * not supported.
     *
     * @return A model manager for the default Firebase app.
     */
    public static function get modelManager():ModelManager {
        return _modelManager;
    }

    /**
     * Enables stats collection in ML Kit model interpreter. The stats include API call counts, errors,
     * API call durations, options, etc. No personally identifiable information is logged.
     *
     * <p>The setting is per <code>FirebaseApp</code>, and therefore per <code>ModelInterpreter</code>, and it is persistent
     * across launches of the app. It means if the user uninstalls the app or clears all app data, the
     * setting will be erased. The best practice is to set the flag in each initialization.</p>
     *
     * <p>By default the logging is enabled. You have to specifically set it to false to disable
     * logging.</p>
     */
    public static function get isStatsCollectionEnabled():Boolean {
        return _isStatsCollectionEnabled;
    }

    public static function set isStatsCollectionEnabled(value:Boolean):void {
        _isStatsCollectionEnabled = value;
    }

    /** Disposes the ANE. */
    public static function dispose():void {
        if (ModelInterpreterANEContext.context) {
            ModelInterpreterANEContext.dispose();
        }
    }
}
}
