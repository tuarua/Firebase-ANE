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
        let fre = FreObjectSwift(freObject)
        self.init()
        self.areTimestampsInSnapshotsEnabled = fre.areTimestampsInSnapshotsEnabled
        self.isSSLEnabled = fre.isSSLEnabled
        self.isPersistenceEnabled = fre.isPersistenceEnabled
    }
    
    func toFREObject() -> FREObject? {
        guard let ret = FreObjectSwift(className: "com.tuarua.firebase.firestore.FirestoreSettings") else { return nil }
        ret.host = host
        ret.isPersistenceEnabled = isPersistenceEnabled
        ret.isSslEnabled = isSSLEnabled
        return ret.rawValue
    }
}
