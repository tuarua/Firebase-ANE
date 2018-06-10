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
