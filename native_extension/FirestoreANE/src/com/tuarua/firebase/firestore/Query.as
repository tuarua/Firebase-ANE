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

package com.tuarua.firebase.firestore {
import com.tuarua.firebase.FirestoreANE;
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.fre.ANEError;

public class Query {
    protected var _path:String;
    protected var _mapTo:Class;

    protected var whereClauses:Vector.<Where> = new <Where>[];
    protected var orderClauses:Vector.<Order> = new <Order>[];
    protected var startAfters:Array = [];
    protected var startAts:Array = [];
    protected var endBefores:Array = [];
    protected var endAts:Array = [];
    protected var limitTo:int = 10000;

    public function Query() {
    }

    public function where(fieldPath:String, operator:String, value:*):Query {
        whereClauses.push(new Where(fieldPath, operator, value));
        return this;
    }

    public function order(by:String, descending:Boolean = false):Query {
        orderClauses.push(new Order(by, descending));
        return this;
    }

    public function limit(to:int):Query {
        limitTo = to;
        return this;
    }

    public function startAfter(...args):Query {
        startAfters = args;
        return this;
    }

    public function startAt(...args):Query {
        startAts = args;
        return this;
    }

    public function endAt(...args):Query {
        endAts = args;
        return this;
    }

    public function endBefore(...args):Query {
        endBefores = args;
        return this;
    }

    public function map(to:Class):void {
        _mapTo = to;
    }

    public function getDocuments(listener:Function):void {
        if (!FirestoreANEContext.isInited) throw new Error(FirestoreANE.INIT_ERROR_MESSAGE);
        var eventId:String = FirestoreANEContext.context.call("createGUID") as String;
        FirestoreANEContext.closures[eventId] = listener;
        FirestoreANEContext.closureCallers[eventId] = this;
        var theRet:* = FirestoreANEContext.context.call("getDocuments", _path, eventId, whereClauses,
                orderClauses, startAts, startAfters, endAts, endBefores, limitTo);
        if (theRet is ANEError) {
            throw theRet as ANEError;
        }
    }

    public function get mapTo():Class {
        return _mapTo;
    }

}
}

