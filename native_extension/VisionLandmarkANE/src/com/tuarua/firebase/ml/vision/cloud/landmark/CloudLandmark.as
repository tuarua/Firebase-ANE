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

package com.tuarua.firebase.ml.vision.cloud.landmark {

import com.tuarua.firebase.ml.vision.common.LatitudeLongitude;

import flash.geom.Rectangle;

[RemoteClass(alias="com.tuarua.firebase.ml.vision.cloud.landmark.CloudLandmark")]
/**
 * Set of landmark properties identified by a vision cloud detector.
 */
public class CloudLandmark {
    /**
     * Overall confidence of the result. The value is float, in range [0, 1].
     */
    public var confidence:Number;
    /**
     * A rectangle image region to which this landmark belongs to (in the view coordinate system).
     */
    public var frame:Rectangle;
    /**
     * Opaque entity ID. Some IDs may be available in [Google Knowledge Graph Search API]
     * (https://developers.google.com/knowledge-graph/).
     */
    public var entityId:String;
    /**
     * Textual description of the landmark.
     */
    public var landmark:String;
    /**
     * <p>The location information for the detected landmark. Multiple LocationInfo elements can be present<br>
     * because one location may indicate the location of the scene in the image, and another location<br>
     * may indicate the location of the place where the image was taken.</p>
     */
    public var locations:Vector.<LatitudeLongitude> = new <LatitudeLongitude>[];

    /** @private */
    public function CloudLandmark() {
    }
}
}