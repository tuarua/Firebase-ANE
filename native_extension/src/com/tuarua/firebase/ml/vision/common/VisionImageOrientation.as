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

package com.tuarua.firebase.ml.vision.common {
public final class VisionImageOrientation {
    /** Orientation code indicating the 0th row is the top and the 0th column is the left side.*/
    public static const topLeft:uint = 1;
    /** Orientation code indicating the 0th row is the top and the 0th column is the right side. */
    public static const topRight:uint = 2;
    /** Orientation code indicating the 0th row is the bottom and the 0th column is the right side.*/
    public static const bottomRight:uint = 3;
    /** Orientation code indicating the 0th row is the bottom and the 0th column is the left side.*/
    public static const bottomLeft:uint = 4;
    /** Orientation code indicating the 0th row is the left side and the 0th column is the top.*/
    public static const leftTop:uint = 5;
    /** Orientation code indicating the 0th row is the right side and the 0th column is the top.*/
    public static const rightTop:uint = 6;
    /** Orientation code indicating the 0th row is the right side and the 0th column is the bottom.*/
    public static const rightBottom:uint = 7;
    /** Orientation code indicating the 0th row is the left side and the 0th column is the bottom. */
    public static const leftBottom:uint = 8;
}
}
