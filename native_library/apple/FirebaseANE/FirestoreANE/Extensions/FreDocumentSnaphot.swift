import Foundation
import FirebaseFirestore

public extension DocumentSnapshot {
    @objc func toDictionary() -> [String: Any] {
        var ret = [String: Any]()
        ret["id"] = self.documentID
        ret["data"] = self.data()
        ret["exists"] = self.exists
        ret["metadata"] = [String: Any](
            dictionaryLiteral: ("isFromCache", self.metadata.isFromCache),
            ("hasPendingWrites", self.metadata.hasPendingWrites)
        )
        return ret
    }
}
