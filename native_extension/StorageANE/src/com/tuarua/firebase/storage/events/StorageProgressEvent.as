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

package com.tuarua.firebase.storage.events {
import flash.events.Event;
import flash.events.ProgressEvent;

public class StorageProgressEvent extends ProgressEvent {
    public static const PROGRESS:String = "StorageProgressEvent.Progress";
    public function StorageProgressEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, bytesLoaded:Number = 0, bytesTotal:Number = 0) {
        super(type, bubbles, cancelable, bytesLoaded, bytesTotal);
    }

    override public function clone():Event {
        return new StorageProgressEvent(type, bubbles, cancelable, bytesTotal, bytesLoaded);
    }

    override public function toString():String {
        return formatToString("StorageProgressEvent", "type", "bubbles", "cancelable", "bytesLoaded", "bytesTotal");
    }
}
}