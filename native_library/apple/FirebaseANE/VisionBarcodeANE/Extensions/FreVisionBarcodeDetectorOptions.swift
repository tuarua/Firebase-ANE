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
import FirebaseMLVision

public extension VisionBarcodeDetectorOptions {
    convenience init?(_ freObject: FREObject?) {
        guard let rv = freObject,
        let formats = [Int].init(rv["formats"])
            else { return nil }
        
        var formatSet: VisionBarcodeFormat = []
        for f in formats {
            formatSet.formUnion(VisionBarcodeFormat(rawValue: f))
        }
        self.init(formats: formatSet)
    }
}

/*
 FIRVisionBarcodeFormatUnKnown = 0,
 /**
 * All format.
 */
 FIRVisionBarcodeFormatAll = 0xFFFF,
 /**
 * Code-128 detection.
 */
 FIRVisionBarcodeFormatCode128 = 0x0001,
 /**
 * Code-39 detection.
 */
 FIRVisionBarcodeFormatCode39 = 0x0002,
 /**
 * Code-93 detection.
 */
 FIRVisionBarcodeFormatCode93 = 0x0004,
 /**
 * Codabar detection.
 */
 FIRVisionBarcodeFormatCodaBar = 0x0008,
 /**
 * Data Matrix detection.
 */
 FIRVisionBarcodeFormatDataMatrix = 0x0010,
 /**
 * EAN-13 detection.
 */
 FIRVisionBarcodeFormatEAN13 = 0x0020,
 /**
 * EAN-8 detection.
 */
 FIRVisionBarcodeFormatEAN8 = 0x0040,
 /**
 * ITF detection.
 */
 FIRVisionBarcodeFormatITF = 0x0080,
 /**
 * QR Code detection.
 */
 FIRVisionBarcodeFormatQRCode = 0x0100,
 /**
 * UPC-A detection.
 */
 FIRVisionBarcodeFormatUPCA = 0x0200,
 /**
 * UPC-E detection.
 */
 FIRVisionBarcodeFormatUPCE = 0x0400,
 /**
 * PDF-417 detection.
 */
 FIRVisionBarcodeFormatPDF417 = 0x0800,
 /**
 * Aztec code detection.
 */
 FIRVisionBarcodeFormatAztec = 0x1000,
 */
