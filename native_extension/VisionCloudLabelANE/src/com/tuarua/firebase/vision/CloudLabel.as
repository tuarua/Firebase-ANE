/*
 * Copyright 2018 Tua Rua Ltd.
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

package com.tuarua.firebase.vision {
[RemoteClass(alias="com.tuarua.firebase.vision.CloudLabel")]
/**
 * Set of label properties identified by a vision cloud detector.
 */
public class CloudLabel {
    /**
     * Overall confidence of the result.  The value is float, in range [0, 1].
     */
    public var confidence:Number;
    /**
     * Opaque entity ID. Some IDs may be available in [Google Knowledge Graph Search API]
     * (https://developers.google.com/knowledge-graph/).
     */
    public var entityId:String;
    /**
     * Textual label name.
     */
    public var label:String;
    /** @private */
    public function CloudLabel() {
    }
}
}
