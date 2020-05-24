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
public final class OSNotificationDisplayType {
    /** Notification is silent, or app is in focus but InAppAlertNotifications are disabled. */
    public static const none:uint = 0;
    /** Default Native Alert View display (note this is not an In-App Message) */
    public static const inAppAlert:uint = 1;
    /** Native native notification display.*/
    public static const notification:uint = 2;
}
}
