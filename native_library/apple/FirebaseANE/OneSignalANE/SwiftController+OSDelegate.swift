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

import Foundation
import FreSwift
import OneSignal

extension SwiftController: OSInAppMessageDelegate,
OSSubscriptionObserver, OSPermissionObserver, OSEmailSubscriptionObserver {

    public func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges?) {
        guard let stateChanges = stateChanges else { return }
        self.dispatchEvent(name: PermissionEvent.ON_AVAILABLE,
                           value: PermissionEvent(json: stateChanges.toDictionary()).toJSONString())
    }

    public func onOSEmailSubscriptionChanged(_ stateChanges: OSEmailSubscriptionStateChanges!) {
        guard let stateChanges = stateChanges else { return }
        self.dispatchEvent(name: EmailSubscriptionEvent.ON_AVAILABLE,
                           value: EmailSubscriptionEvent(json: stateChanges.toDictionary()).toJSONString())
    }

    public func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        guard let stateChanges = stateChanges else { return }
        self.dispatchEvent(name: SubscriptionEvent.ON_AVAILABLE,
                           value: SubscriptionEvent(json: stateChanges.toDictionary()).toJSONString())
    }
}
