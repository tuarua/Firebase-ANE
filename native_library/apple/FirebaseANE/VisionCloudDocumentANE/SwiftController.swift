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
import FirebaseMLVision

public class SwiftController: NSObject {
    public static var TAG = "SwiftController"
    public var context: FreContextSwift!
    public var functionsToSet: FREFunctionMap = [:]
    private let userInitiatedQueue = DispatchQueue(label: "com.tuarua.vision.cdc.uiq", qos: .userInitiated)
    private var results: [String: VisionDocumentText] = [:]
    private var recognizer: VisionDocumentTextRecognizer?
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let options = VisionCloudDocumentTextRecognizerOptions(argv[0])
            else {
                return FreArgError().getError()
        }
        recognizer = Vision.vision().cloudDocumentTextRecognizer(options: options)
        return true.toFREObject()
    }
    
    func process(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let image = VisionImage(argv[0]),
            let eventId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        userInitiatedQueue.async {
            self.recognizer?.process(image, completion: { (result, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: CloudDocumentEvent.RECOGNIZED,
                                       value: CloudDocumentEvent(eventId: eventId, error: err).toJSONString())
                } else {
                    if let result = result {
                        self.results[eventId] = result
                        self.dispatchEvent(name: CloudDocumentEvent.RECOGNIZED,
                                           value: CloudDocumentEvent(eventId: eventId).toJSONString())
                    }
                }
            })
        }
        return nil
    }
    
    func getResults(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        return results[eventId]?.toFREObject(id: eventId)
    }
    
    func getBlocks(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let resultId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        guard let document = results[resultId]  else { return nil }
        return document.blocks.toFREObject(resultId: resultId)
    }
    
    func getParagraphs(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let resultId = String(argv[0]),
            let blockIndex = Int(argv[1])
            else {
                return FreArgError().getError()
        }
        guard let document = results[resultId],
            document.blocks.count > blockIndex else { return nil }
        
        let block = document.blocks[blockIndex]
        return block.paragraphs.toFREObject(resultId: resultId, blockIndex: blockIndex)
    }
    
    func getWords(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 2,
            let resultId = String(argv[0]),
            let blockIndex = Int(argv[1]),
            let paragraphIndex = Int(argv[2])
            else {
                return FreArgError().getError()
        }
        guard let document = results[resultId],
            document.blocks.count > blockIndex else { return nil }
        
        let block = document.blocks[blockIndex]
        if block.paragraphs.count > paragraphIndex {
            let paragraph = block.paragraphs[paragraphIndex]
            return paragraph.words.toFREObject(resultId: resultId, blockIndex: blockIndex,
                                               paragraphIndex: paragraphIndex)
        }

        return nil
    }
    
    func getSymbols(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 3,
            let resultId = String(argv[0]),
            let blockIndex = Int(argv[1]),
            let paragraphIndex = Int(argv[2]),
            let wordIndex = Int(argv[3])
            else {
                return FreArgError().getError()
        }
        guard let document = results[resultId],
            document.blocks.count > blockIndex else { return nil }
        
        let block = document.blocks[blockIndex]
        if block.paragraphs.count > paragraphIndex {
            let paragraph = block.paragraphs[paragraphIndex]
            if paragraph.words.count > wordIndex {
                let word = paragraph.words[wordIndex]
                return word.symbols.toFREObject()
            }
        }

        return nil
    }
    
    func disposeResult(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let id = String(argv[0])
            else {
                return FreArgError().getError()
        }
        results[id] = nil
        return nil
    }
    
    func close(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
}
