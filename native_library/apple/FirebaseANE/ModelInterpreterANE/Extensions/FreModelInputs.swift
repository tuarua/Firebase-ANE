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

public extension ModelInputs {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
            let freInputs = rv["input"]
            else { return nil }
        self.init()
        let asByteArray = FreByteArraySwift(freByteArray: freInputs)
        if let byteData = asByteArray.value {
            do {
                try self.addInput(byteData)
            } catch let e as NSError {
                asByteArray.releaseBytes()
                FreSwiftLogger.shared.error(message: e.localizedDescription,
                                          type: .invalidArgument, line: #line, column: #column, file: #file)
                return nil
            } catch {
                asByteArray.releaseBytes()
                return nil
            }
        }
        asByteArray.releaseBytes()
    }
}
