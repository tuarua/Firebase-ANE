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
import flash.display.BitmapData;
[RemoteClass(alias="com.tuarua.firebase.vision.VisionImage")]
public class VisionImage {
    private var _bitmapdata:BitmapData;
    private var _metadata:VisionImageMetadata = new VisionImageMetadata();

    public function VisionImage(bitmapdata:BitmapData, metadata:VisionImageMetadata = null) {
        this._bitmapdata = bitmapdata;
        if(metadata != null){
            this._metadata = metadata;
        }
    }

    public function get bitmapdata():BitmapData {
        return _bitmapdata;
    }

    public function get metadata():VisionImageMetadata {
        return _metadata;
    }
}
}
