import Foundation
import FirebaseFirestore

public extension DocumentChange {
    func toDictionary() -> [String: Any] {
        var ret = [String: Any]()
        ret["type"] = self.type.rawValue
        ret["newIndex"] = self.newIndex
        ret["oldIndex"] = self.oldIndex
        ret["id"] = self.document.documentID
        return ret
    }
}
