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

package com.tuarua.firebase.firestore.events {
import com.tuarua.firebase.firestore.DocumentSnapshot;

import flash.events.Event;

public class DocumentEvent extends Event {
    public static const SNAPSHOT:String = "DocumentEvent.Snapshot";
    public static const COMPLETE:String = "DocumentEvent.Complete";
    public var data:DocumentSnapshot;
    public var realtime:Boolean;

    public function DocumentEvent(type:String, data:DocumentSnapshot = null, realtime:Boolean = false, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
        this.realtime = realtime;
    }

    public override function clone():Event {
        return new DocumentEvent(type, this.data, this.realtime, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("DocumentEvent", "data", "type", "realtime", "bubbles", "cancelable");
    }
}
}
