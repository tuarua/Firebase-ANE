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
import com.tuarua.firebase.firestore.QuerySnapshot;

import flash.events.Event;

public class QueryEvent extends Event {
    public static const QUERY_SNAPSHOT:String = "QueryEvent.QuerySnapshot";
    public var snapshot:QuerySnapshot;
    public function QueryEvent(type:String, snapshot:QuerySnapshot, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.snapshot = snapshot;
    }
    public override function clone():Event {
        return new QueryEvent(type, this.snapshot, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("QueryEvent", "snapshot", "type", "bubbles", "cancelable");
    }
}
}
