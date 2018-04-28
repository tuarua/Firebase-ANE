import Foundation
import FirebaseFirestore

public extension QuerySnapshot {
    func toDictionary() -> [String: Any] {
        var ret = [String: Any]()
        ret["metadata"] = [String: Any](
            dictionaryLiteral: ("isFromCache", self.metadata.isFromCache),
            ("hasPendingWrites", self.metadata.hasPendingWrites)
        )
        var docChangeArr: [[String: Any]] = []
        for dc in self.documentChanges {
            docChangeArr.append(dc.toDictionary())
        }
        ret["documentChanges"] = docChangeArr
        
        var docArr: [[String: Any]] = []
        for doc in self.documents {
            docArr.append(doc.toDictionary())
        }
        ret["documents"] = docArr
        return ret
    }
    
}
