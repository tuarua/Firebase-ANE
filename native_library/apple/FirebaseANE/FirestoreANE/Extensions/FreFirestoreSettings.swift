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
