/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.face {
import flash.geom.Point;

[RemoteClass(alias="com.tuarua.mlkit.vision.face.FaceLandmark")]
/**
 * A landmark on a human face detected in an image.
 */
public class FaceLandmark {
    private var _position:Point;
    private var _type:String;

    /** @private */
    public function FaceLandmark(position:Point, type:String) {
        this._position = position;
        this._type = type;
    }

    /**
     * 2D position of the facial landmark.
     */
    public function get position():Point {
        return _position;
    }

    /**
     * The type of the facial landmark.
     */
    public function get type():String {
        return _type;
    }
}
}
