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
import FirebaseCore

public extension FirebaseOptions {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.FirebaseOptions")
            try ret?.setProp(name: "bundleId", value: self.bundleID)
            try ret?.setProp(name: "androidClientId", value: self.androidClientID)
            try ret?.setProp(name: "trackingId", value: self.trackingID)
            try ret?.setProp(name: "apiKey", value: self.apiKey)
            try ret?.setProp(name: "googleAppId", value: self.googleAppID)
            try ret?.setProp(name: "databaseUrl", value: self.databaseURL)
            try ret?.setProp(name: "storageBucket", value: self.storageBucket)
            try ret?.setProp(name: "clientId", value: self.clientID)
            try ret?.setProp(name: "projectId", value: self.projectID)
            try ret?.setProp(name: "gcmSenderId", value: self.gcmSenderID)
            try ret?.setProp(name: "deepLinkUrlScheme", value: self.deepLinkURLScheme)
            return ret
        } catch {
        }
        return nil
    }
}
