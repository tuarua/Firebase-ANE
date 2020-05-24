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

package com.tuarua.onesignal.events {
import com.tuarua.onesignal.OSEmailSubscriptionState;

import flash.events.Event;

public class EmailSubscriptionEvent extends Event {
    public static const ON_CHANGE:String = "EmailSubscriptionEvent.OnChange";
    public var from:OSEmailSubscriptionState;
    public var to:OSEmailSubscriptionState;

    public function EmailSubscriptionEvent(type:String, from:OSEmailSubscriptionState, to:OSEmailSubscriptionState, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.from = from;
        this.to = to;
    }

    public override function clone():Event {
        return new EmailSubscriptionEvent(type, this.from, this.to, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("EmailSubscriptionEvent", "from", "to", "type", "bubbles", "cancelable");
    }
}
}
