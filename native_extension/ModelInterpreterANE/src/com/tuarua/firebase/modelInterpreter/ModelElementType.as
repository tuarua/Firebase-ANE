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
/** This enum specifies the type of elements in the custom model's input or output. */
public final class ModelElementType {
    /** Element type unknown/undefined. */
    public static const unknown:uint = 0;
    /** 32-bit single precision floating point. */
    public static const float32:uint = 1;
    /** 32-bit signed integer. */
    public static const int32:uint = 2;
    /** 8-bit unsigned integer. */
    public static const byte:uint = 3;
    /** 64-bit signed integer. */
    public static const long:int = 4;
}
}