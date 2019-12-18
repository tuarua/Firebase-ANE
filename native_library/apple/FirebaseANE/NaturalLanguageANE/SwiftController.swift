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
    private let userInitiatedQueue = DispatchQueue(label: "com.tuarua.naturalLanguage.uiq", qos: .userInitiated)
    private var results: [String: String] = [:]
    private var resultsMulti: [String: [IdentifiedLanguage]] = [:]
    private var languageIdentification: LanguageIdentification?
    
    func createGUID(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return UUID().uuidString.toFREObject()
    }
    
    func initController(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let isStatsCollectionEnabled = Bool(argv[1])
            else {
                return FreArgError().getError()
        }
        if let options = LanguageIdentificationOptions(argv[0]) {
            languageIdentification = NaturalLanguage.naturalLanguage().languageIdentification(options: options)
        } else {
            languageIdentification = NaturalLanguage.naturalLanguage().languageIdentification()
        }
        NaturalLanguage.naturalLanguage().isStatsCollectionEnabled = isStatsCollectionEnabled
        return true.toFREObject()
    }
    
    func identifyLanguage(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let text = String(argv[0]),
            let eventId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        userInitiatedQueue.async {
            self.languageIdentification?.identifyLanguage(for: text, completion: { (result, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: LanguageEvent.RECOGNIZED,
                                       value: LanguageEvent(eventId: eventId, error: err).toJSONString()
                    )
                } else {
                    if let result = result, result != "und" {
                        self.results[eventId] = result
                        self.dispatchEvent(name: LanguageEvent.RECOGNIZED,
                                           value: LanguageEvent(eventId: eventId).toJSONString())
                    }
                }
            })
        }
        return nil
    }
    
    func identifyPossibleLanguages(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 1,
            let text = String(argv[0]),
            let eventId = String(argv[1])
            else {
                return FreArgError().getError()
        }
        userInitiatedQueue.async {
            self.languageIdentification?.identifyPossibleLanguages(for: text, completion: { (result, error) in
                if let err = error as NSError? {
                    self.dispatchEvent(name: LanguageEvent.RECOGNIZED_MULTI,
                                       value: LanguageEvent(eventId: eventId, error: err).toJSONString()
                    )
                } else {
                    if let result = result, !result.isEmpty {
                        self.resultsMulti[eventId] = result
                        self.dispatchEvent(name: LanguageEvent.RECOGNIZED_MULTI,
                                           value: LanguageEvent(eventId: eventId).toJSONString())
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
        let ret = results[eventId]?.toFREObject()
        results[eventId] = nil
        return ret
    }
    
    func getResultsMulti(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        guard argc > 0,
            let eventId = String(argv[0])
            else {
                return FreArgError().getError()
        }
        let ret = resultsMulti[eventId]?.toFREObject()
        resultsMulti[eventId] = nil
        return ret
    }
    
    func close(ctx: FREContext, argc: FREArgc, argv: FREArgv) -> FREObject? {
        return nil
    }
    
}
