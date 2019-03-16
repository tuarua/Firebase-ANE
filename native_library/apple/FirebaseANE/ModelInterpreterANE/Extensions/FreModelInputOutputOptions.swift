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
import FirebaseMLCommon
import FirebaseMLModelInterpreter

public extension ModelInputOutputOptions {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let inputIndex = UInt(rv["inputIndex"]),
            let outputIndex = UInt(rv["outputIndex"]),
            let inputTypeRaw = UInt(rv["inputType"]),
            let inputType = ModelElementType(rawValue: inputTypeRaw),
            let outputTypeRaw = UInt(rv["outputType"]),
            let outputType = ModelElementType(rawValue: outputTypeRaw),
            let inputDimensionsDbl = [Double](rv["inputDimensions"]),
            let outputDimensionsDbl = [Double](rv["outputDimensions"])
            else { return nil }
        self.init()
        var inputDimensions: [NSNumber] = []
        for v in inputDimensionsDbl {
            inputDimensions.append(NSNumber(value: v))
        }
        var outputDimensions: [NSNumber] = []
        for v in outputDimensionsDbl {
            outputDimensions.append(NSNumber(value: v))
        }
        do {
            try self.setInputFormat(index: inputIndex,
                                    type: inputType,
                                    dimensions: inputDimensions)
            try self.setOutputFormat(index: outputIndex,
                                     type: outputType,
                                     dimensions: outputDimensions)
        } catch {
            return nil 
        }
    }
}
