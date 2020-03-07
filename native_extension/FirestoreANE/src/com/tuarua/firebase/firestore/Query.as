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
import com.tuarua.firebase.FirestoreANEContext;
import com.tuarua.fre.ANEError;

public class Query {
    /**@private */
    protected var _path:String;
    /**@private */
    protected var _mapTo:Class;
    /**@private */
    protected var whereClauses:Vector.<Where> = new <Where>[];
    /**@private */
    protected var orderClauses:Vector.<Order> = new <Order>[];
    /**@private */
    protected var startAfters:Array = [];
    /**@private */
    protected var startAts:Array = [];
    /**@private */
    protected var endBefores:Array = [];
    /**@private */
    protected var endAts:Array = [];
    /**@private */
    protected var limitTo:int = 10000;

    public function Query() {
    }

    /**
     * Creates a new query that returns only documents that include the specified fields and where
     * the values satisfy the constraints provided.
     * @param fieldPath The path to compare.
     * @param operator The operation string (e.g "&lt;", "&lt;=", "==", "&gt;", "&gt;=").
     * @param value The value for comparison.
     */
    public function where(fieldPath:String, operator:String, value:*):Query {
        whereClauses.push(new Where(fieldPath, operator, value));
        return this;
    }

    /**
     * Creates a new query where the results are sorted by the specified field, in descending or ascending order.
     * @param by The field to sort by.
     * @param descending direction to sort by
     */
    public function order(by:String, descending:Boolean = false):Query {
        orderClauses.push(new Order(by, descending));
        return this;
    }

    /**
     * Creates a new query where the results are limited to the specified number of documents.
     * @param to The maximum number of items to return.
     */
    public function limit(to:int):Query {
        limitTo = to;
        return this;
    }

    /**
     * Creates a new query where the results start after the provided document (exclusive).
     * The starting position is relative to the order of the query. The document must contain all of the
     * fields provided in the orderBy of this query.
     * @param args
     */
    public function startAfter(...args):Query {
        startAfters = args;
        return this;
    }

    /**
     * Creates a new query where the results start at the provided document (inclusive).
     * The starting position is relative to the order of the query. The document must contain all of the
     * fields provided in the orderBy of the query.
     * @param args
     */
    public function startAt(...args):Query {
        startAts = args;
        return this;
    }

    /**
     * Creates a new query where the results end at the provided document (inclusive).
     * The end position is relative to the order of the query. The document must contain all of the
     * fields provided in the orderBy of this query.
     * @param args
     */
    public function endAt(...args):Query {
        endAts = args;
        return this;
    }

    /**
     * Creates a new query where the results end before the provided document (exclusive).
     * The end position is relative to the order of the query. The document must contain all of the
     * fields provided in the orderBy of this query.
     * @param args
     */
    public function endBefore(...args):Query {
        endBefores = args;
        return this;
    }

    /**
     * Converts the Document into an as3 Class with properties mapped to the Document's fields.
     * @param to AS3 class to map to
     */
    public function map(to:Class):void {
        _mapTo = to;
    }

    /**
     * Executes the query and returns the results as a QuerySnapshot
     *
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(snapshot:QuerySnapshot, error:FirestoreError):void {
     *
     * }
     * </listing>
     */
    public function getDocuments(listener:Function):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("getDocuments", _path,
                FirestoreANEContext.createCallback(listener, this), whereClauses,
                orderClauses, startAts, startAfters, endAts, endBefores, limitTo);
        if (ret is ANEError) throw ret as ANEError;
    }

    /**@private */
    public function get mapTo():Class {
        return _mapTo;
    }

}
}

