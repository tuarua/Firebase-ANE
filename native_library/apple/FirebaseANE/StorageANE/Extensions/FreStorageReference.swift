import Foundation
import FreSwift
import FirebaseStorage

public extension StorageReference {
    func toFREObject() -> FREObject? {
        do {
            let ret = try FREObject(className: "Object")
            try ret?.setProp(name: "bucket", value: self.bucket)
            try ret?.setProp(name: "name", value: self.name)
            try ret?.setProp(name: "path", value: self.fullPath)
            return ret
        } catch {
        }
        return nil
    }
}
