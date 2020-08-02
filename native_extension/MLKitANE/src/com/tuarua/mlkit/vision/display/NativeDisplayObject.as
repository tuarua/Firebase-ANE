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

package com.tuarua.mlkit.vision.display {
import com.tuarua.mlkit.MLKitANEContext;

public class NativeDisplayObject {
    private var _x:int;
    private var _y:int;
    private var _visible:Boolean = true;
    private var _alpha:Number = 1.0;
    protected var _id:String;
    protected static const IMAGE_TYPE:int = 0;
    protected static const BUTTON_TYPE:int = 1;
    public var type:int;
    private var _isAdded:Boolean = false;

    public function NativeDisplayObject() {
        this._id = MLKitANEContext.context.call("createGUID") as String;
    }

    public function set x(value:int):void {
        _x = value;
        update("x", value);
    }

    public function set y(value:int):void {
        _y = value;
        update("y", value);
    }

    public function set visible(value:Boolean):void {
        _visible = value;
        update("visible", value);
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function get visible():Boolean {
        return _visible;
    }

    public function get id():String {
        return _id;
    }

    public function get isAdded():Boolean {
        return _isAdded;
    }

    public function set isAdded(value:Boolean):void {
        _isAdded = value;
    }

    public function get alpha():Number {
        return _alpha;
    }

    public function set alpha(value:Number):void {
        _alpha = value;
        update("alpha", value);
    }

    protected function update(type:String, value:*):void {
        if (MLKitANEContext.context == null) return;
        try {
            MLKitANEContext.context.call("updateNativeChild", _id, type, value);
        } catch (e:Error) {
            trace(e.message);
        }
    }
}
}
