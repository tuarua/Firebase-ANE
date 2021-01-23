/*
 * Copyright 2021 Tua Rua Ltd.
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

package com.tuarua.firebase.firestore {
public class FieldValue {
    /**
     * Returns a sentinel for use with set() or update() to include a server-generated
     * timestamp in the written data.
     */
    public static function serverTimestamp():FieldValue {
        return new ServerTimestampFieldValue();
    }

    /** Returns a sentinel for use with update() to mark a field for deletion. */
    public static function remove():FieldValue {
        return new DeleteFieldValue();
    }

    /**
     * Returns a special value that can be used with set() or update() that tells the
     * server to increment the field's current value by the given value.
     *
     * <p>If the current value is an integer or a double, both the current and the given value will be
     * interpreted as doubles and all arithmetic will follow IEEE 754 semantics. Otherwise, the
     * transformation will set the field to the given value.
     *
     * @return The FieldValue sentinel for use in a call to set() or update().
     */
    public static function increment(value: Number):FieldValue {
        return new NumericIncrementFieldValue(value);
    }
}
}
