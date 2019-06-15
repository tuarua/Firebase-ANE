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

package com.tuarua.firebase.ml.vision.document {
public final class DocumentBlockType {
    /**
     * Unknown document text block type.
     */
    public static const unknown:uint = 0;
    /**
     * Barcode document text block type.
     */
    public static const barcode:uint = 1;
    /**
     * Image document text block type.
     */
    public static const picture:uint = 2;
    /**
     * Horizontal/vertical line box document text block type.
     */
    public static const ruler:uint = 3;
    /**
     * Table document text block type.
     */
    public static const table:uint = 4;
    /**
     * Regular document text block type.
     */
    public static const text:uint = 5;
}
}
