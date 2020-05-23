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
import flash.events.Event;

public class IdsEvent extends Event {
    public static const ON_AVAILABLE:String = "IdsEvent.OnAvailable";
    public var userId:String;
    public var registrationId:String;

    public function IdsEvent(type:String, userId:String, registrationId:String, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.userId = userId;
        this.registrationId = registrationId;
    }

    public override function clone():Event {
        return new IdsEvent(type, this.userId, this.registrationId, bubbles, cancelable);
    }

    public override function toString():String {
        return formatToString("IdsEvent", "userId", "registrationId", "type", "bubbles", "cancelable");
    }
}
}
