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

package com.tuarua.firebase {
import com.tuarua.firebase.firestore.CollectionReference;
import com.tuarua.firebase.firestore.DocumentReference;
import com.tuarua.firebase.firestore.FirestoreSettings;
import com.tuarua.firebase.firestore.WriteBatch;
import com.tuarua.fre.ANEError;

import flash.events.EventDispatcher;

public final class FirestoreANE extends EventDispatcher {
    private static var _firestore:FirestoreANE;
    private static var _loggingEnabled:Boolean = false;
    private static var _settings:FirestoreSettings = new FirestoreSettings();

    /** @private */
    public function FirestoreANE() {
        if (FirestoreANEContext.context) {
            var ret:* = FirestoreANEContext.context.call("init", _loggingEnabled, _settings);
            if (ret is ANEError) throw ret as ANEError;
        }
        _firestore = this;
    }

    /** The ANE instance. */
    public static function get firestore():FirestoreANE {
        if (!_firestore) {
            new FirestoreANE();
        }
        return _firestore;
    }

    public function batch():WriteBatch {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("startBatch");
        if (ret is ANEError) throw ret as ANEError;
        return new WriteBatch();
    }

    public function get settings():FirestoreSettings {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("getFirestoreSettings");
        if (ret is ANEError) throw ret as ANEError;
        return ret as FirestoreSettings;
    }

    public function collection(collectionPath:String):CollectionReference {
        FirestoreANEContext.validate();
        return new CollectionReference(collectionPath);
    }

    public function document(documentPath:String = null):DocumentReference {
        FirestoreANEContext.validate();
        return new DocumentReference(documentPath);
    }

    /** Whether logging from the Firestore client is enabled/disabled. */
    public static function get loggingEnabled():Boolean {
        return _loggingEnabled;
    }

    public static function set loggingEnabled(value:Boolean):void {
        _loggingEnabled = value;
    }

    /**
     * Re-enables usage of the network by this Firestore instance after a prior call to
     * <code>disableNetwork</code>.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:FirestoreError):void {
     *
     * }
     * </listing>
     */
    public function enableNetwork(listener:Function = null):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("enableNetwork", FirestoreANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    /**
     * Disables usage of the network by this Firestore instance. It can be re-enabled by via
     * <code>enableNetwork</code>. While the network is disabled, any snapshot listeners or get calls
     * will return results from cache and any write operations will be queued until the network is
     * restored.
     * @param listener Optional Function to be called on completion.
     * The function is expected to have the following signature:
     * <listing version="3.0">
     * function callback(error:FirestoreError):void {
     *
     * }
     * </listing>
     */
    public function disableNetwork(listener:Function = null):void {
        FirestoreANEContext.validate();
        var ret:* = FirestoreANEContext.context.call("disableNetwork", FirestoreANEContext.createCallback(listener));
        if (ret is ANEError) throw ret as ANEError;
    }

    public static function set settings(value:FirestoreSettings):void {
        _settings = value;
    }

    /** Disposes the ANE */
    public static function dispose():void {
        if (FirestoreANEContext.context) {
            FirestoreANEContext.dispose();
        }
    }
}
}
