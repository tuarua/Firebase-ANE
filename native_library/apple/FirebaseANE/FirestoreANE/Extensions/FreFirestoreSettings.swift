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
import FirebaseFirestore
import FreSwift

public extension FirestoreSettings {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let areTimestampsInSnapshotsEnabled = Bool(rv["areTimestampsInSnapshotsEnabled"]),
            let isSSLEnabled = Bool(rv["isSSLEnabled"]),
            let isPersistenceEnabled = Bool(rv["isPersistenceEnabled"])
            else { return nil }
        self.init()
        self.areTimestampsInSnapshotsEnabled = areTimestampsInSnapshotsEnabled
        self.isSSLEnabled = isSSLEnabled
        self.isPersistenceEnabled = isPersistenceEnabled
    }
    
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "com.tuarua.firebase.firestore.FirestoreSettings")
            try ret?.setProp(name: "host", value: self.host)
            try ret?.setProp(name: "isPersistenceEnabled", value: self.isPersistenceEnabled)
            try ret?.setProp(name: "isSslEnabled", value: self.isSSLEnabled)
            return ret
        } catch {
        }
        return nil
    }
}
