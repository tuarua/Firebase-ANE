import Foundation
import FreSwift
import FirebaseStorage

public extension StorageMetadata {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject
            else { return nil }
        self.init()
        let cacheControl = String(rv["cacheControl"])
        let contentDisposition = String(rv["contentDisposition"])
        let contentEncoding = String(rv["contentEncoding"])
        let contentLanguage = String(rv["contentLanguage"])
        let contentType = String(rv["contentType"])
        let customMetadataFre: [String: Any]? = [String: Any](rv["customMetadata"])
        var customMetadata: [String: String] = [:]
        if cacheControl != nil {
            self.cacheControl = cacheControl
        }
        if contentDisposition != nil {
            self.contentDisposition = contentDisposition
        }
        if contentEncoding != nil {
            self.contentEncoding = contentEncoding
        }
        if contentLanguage != nil {
            self.contentLanguage = contentLanguage
        }
        if contentType != nil {
            self.contentType = contentType
        }
        
        if let cmf = customMetadataFre {
            for cm in cmf {
                customMetadata[cm.key] = cm.value as? String
            }
            self.customMetadata = customMetadata
        }
        
    }
}
