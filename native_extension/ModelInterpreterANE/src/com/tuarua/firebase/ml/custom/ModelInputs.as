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
import flash.utils.ByteArray;

/**
 * Input data for a Firebase custom model.
 */
public class ModelInputs {
    private var _input:ByteArray;

    public function ModelInputs() {
    }

    /**
     * Appends an input at the next index. The index starts from 0 and is incremented each time an
     * input is added.
     * @param value Input data for the next index. Input can be <code>ByteArray</code>, or a one-dimensional or multi-dimensional
     * array of <code>Number</code>s (Number, int, string).
     */
    public function addInput(value:ByteArray):void {
        if (value == null) throw new ArgumentError("cannot add null value as input");
        _input = value;
    }

    public function get input():ByteArray {
        return _input;
    }
}
}
