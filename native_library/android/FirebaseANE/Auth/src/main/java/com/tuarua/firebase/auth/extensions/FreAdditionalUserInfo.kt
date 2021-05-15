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

package com.tuarua.firebase.auth.extensions

import com.google.firebase.auth.AdditionalUserInfo

fun AdditionalUserInfo.toMap(): Map<String, Any?> {
    return mapOf(
            "providerId" to providerId,
            "username" to username,
            "isNewUser" to isNewUser,
            "profile" to profile
    )
}