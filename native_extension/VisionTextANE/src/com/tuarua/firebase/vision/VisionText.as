/*
 *  Copyright 2018 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.tuarua.firebase.vision {
import flash.geom.Point;
import flash.geom.Rectangle;

public class VisionText {
    /**
     * The rectangle that holds the discovered text relative to the detected image in the view
     * coordinate system.
     */
    public var frame:Rectangle;
    /**
     * Recognized text string.
     */
    public var text:String;
    /**
     * <p>The four corner points of the text, in clockwise order starting with the top left relative<br>
     * to the detected image in the view coordinate system. </p>
     */
    public var cornerPoints:Vector.<Point> = new <Point>[];
    /** @private */
    public function VisionText() {
    }
}
}
