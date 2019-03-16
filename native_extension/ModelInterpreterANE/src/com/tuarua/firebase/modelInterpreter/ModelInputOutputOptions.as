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
 * Options for a custom model specifying input and output data types and dimensions.
 */
public class ModelInputOutputOptions {
    private var _inputIndex:uint;
    private var _inputType:uint;
    private var _inputDimensions:Array;
    private var _outputIndex:uint;
    private var _outputType:uint;
    private var _outputDimensions:Array;
    public function ModelInputOutputOptions() {
    }
    /**
     * Sets the type and dimensions for the input at a given index.
     *
     * @param index The index of the input to configure.
     * @param type The element type for the input at a given index.
     * @param dimensions The array of dimensions for the input at a given index.  Each
     * dimension should have an <code>uint</code> value.  For example, for a 2 dimensional input with 4 rows
     * and 9 columns, the corresponding dimensions should be provided as an <code>Array</code> containing two
     * <code>Number</code>s with unsigned integer values, 4 and 9 respectively.
     */
    public function setInputFormat(index: uint, type: uint, dimensions: Array):void {
        _inputIndex = index;
        _inputType = type;
        _inputDimensions = dimensions;
    }

    /**
     * Sets the type and dimensions for the output at a given index.
     *
     * @param index The index of the output to configure.
     * @param type The element type for the output at a given index.
     * @param dimensions The array of dimensions for the output at a given index.  Each dimension should
     * have an <code>uint</code> value.  For example, for a 2 dimensional output with 4 rows and 9 columns,
     * the corresponding dimensions should be provided as an <code>Array</code> containing two <code>Number</code>s with
     *     unsigned integer values, 4 and 9 respectively.
     */
    public function setOutputFormat(index: uint, type: uint, dimensions: Array):void {
        _outputIndex = index;
        _outputType = type;
        _outputDimensions = dimensions;
    }

    /** The index of the input to configure. */
    public function get inputIndex():uint {
        return _inputIndex;
    }

    /** The element type for the input at a given index.*/
    public function get inputType():uint {
        return _inputType;
    }

    /** The array of dimensions for the input at a given index. */
    public function get inputDimensions():Array {
        return _inputDimensions;
    }

    /** The index of the output to configure.*/
    public function get outputIndex():uint {
        return _outputIndex;
    }
    /** The element type for the output at a given index.*/
    public function get outputType():uint {
        return _outputType;
    }

    /** The array of dimensions for the output at a given index. */
    public function get outputDimensions():Array {
        return _outputDimensions;
    }
}
}
