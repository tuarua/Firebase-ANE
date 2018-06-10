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
import FirebaseDynamicLinks

extension DynamicLinkIOSParameters {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
        let bundleId = String(rv["bundleId"])
            else { return nil }
        self.init(bundleID: bundleId)
        self.customScheme = String(rv["customScheme"])
        self.appStoreID = String(rv["appStoreId"])
        if let fallbackUrl = String(rv["fallbackUrl"]) {
           self.fallbackURL = URL(string: fallbackUrl)
        }
        if let ipadFallbackUrl = String(rv["ipadFallbackUrl"]) {
            self.iPadFallbackURL = URL(string: ipadFallbackUrl)
        }
        self.iPadBundleID = String(rv["ipadBundleId"])
        self.minimumAppVersion = String(rv["minimumVersion"])
    }
}
