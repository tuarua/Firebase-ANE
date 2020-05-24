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

package com.tuarua.onesignal {
public final class OSNotificationPermission {
    // The user has not yet made a choice regarding whether your app can show notifications.
    public static const notDetermined:uint = 0;
    // The application is not authorized to post user notifications.
    public static const denied:uint = 1;
    // The application is authorized to post user notifications.
    public static const authorized:uint = 2;
    // the application is only authorized to post Provisional notifications (direct to history)
    public static const provisional:uint = 3;
}
}