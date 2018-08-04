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
import Firebase

public extension ModelInputOutputOptions {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let inputFormat = ModelInputOutputFormat(rv["inputFormat"]),
            let outputFormat = ModelInputOutputFormat(rv["outputFormat"])
            else { return nil }
        self.init()
        do {
            try self.setInputFormat(index: inputFormat.index,
                                    type: inputFormat.type,
                                    dimensions: inputFormat.dimensions)
            try self.setOutputFormat(index: outputFormat.index,
                                     type: outputFormat.type,
                                     dimensions: outputFormat.dimensions)
        } catch {
            return nil 
        }
    }
}

class ModelInputOutputFormat: NSObject {
    var index: UInt
    var type: ModelElementType
    var dimensions: [NSNumber] = []
    init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let index = UInt(rv["index"]),
            let freType = UInt(rv["type"]),
            let dimensions = [Double](rv["dimensions"]),
            let type = ModelElementType(rawValue: freType)
            else { return nil }
        
        self.index = index
        self.type = type
        for dimension in dimensions {
            self.dimensions.append(NSNumber(value: dimension))
        }
    }
}
