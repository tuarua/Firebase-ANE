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

package com.tuarua.firebase.storage {
import com.tuarua.firebase.StorageANEContext;

import flash.events.EventDispatcher;

public class StorageTask extends EventDispatcher {
    protected var _asId:String;
    protected var _referenceId:String;
    /** @private */
    public function StorageTask(referenceId:String) {
        this._referenceId = referenceId;
        this._asId = StorageANEContext.context.call("createGUID") as String;
    }

    override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false,
                                              priority:int = 0, useWeakReference:Boolean = false):void {
        StorageANEContext.validate();
        StorageANEContext.listeners.push(
                {
                    "id": _asId,
                    "type": type,
                    "listener": listener
                }
        );
        if (!StorageANEContext.listenersObjects[_asId]) StorageANEContext.listenersObjects[_asId] = this;
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);
        StorageANEContext.context.call("addEventListener", _asId, type);
    }

    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        StorageANEContext.validate();
        delete StorageANEContext.listenersObjects[_asId];
        var obj:Object;
        var length:int = StorageANEContext.listeners.length;
        for (var i:int = 0; i < length; ++i) {
            obj = StorageANEContext.listeners[i];
            if (obj.type == type && obj.id == _asId) {
                StorageANEContext.listeners.removeAt(i);
                break;
            }
        }
        super.removeEventListener(type, listener, useCapture);
        StorageANEContext.context.call("removeEventListener", _asId, type);
    }
    /**
     * Pauses a task currently in progress.
     */
    public function pause():void {
        StorageANEContext.validate();
        StorageANEContext.context.call("pauseTask", _asId);
    }
    /**
     * Resumes a task that is paused.
     */
    public function resume():void {
        StorageANEContext.validate();
        StorageANEContext.context.call("resumeTask", _asId);
    }
    /**
     * Cancels a task currently in progress.
     */
    public function cancel():void {
        StorageANEContext.validate();
        StorageANEContext.context.call("cancelTask", _asId);
    }
    /** @private */
    public function get asId():String {
        return _asId;
    }
}
}
