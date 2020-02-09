/*
 * Copyright 2019 Tua Rua Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.tuarua.firebase.ml.naturallanguage {
import com.tuarua.firebase.ml.naturallanguage.languageid.LanguageIdentification;
import com.tuarua.firebase.ml.naturallanguage.languageid.LanguageIdentificationOptions;

import flash.events.EventDispatcher;

public class NaturalLanguage extends EventDispatcher {
    private var _languageIdentification:LanguageIdentification;
    //noinspection JSFieldCanBeLocal
    private static var _naturalLanguage:NaturalLanguage;
    private static var _isStatsCollectionEnabled:Boolean = true;

    /** @private */
    public function NaturalLanguage() {
        _naturalLanguage = this;
    }

    /**
     * Gets a language identification instance with the given options.
     *
     * @param options The options used for language identification.
     * @return A new instance of <code>LanguageIdentification</code> with the given options.
     */
    public function languageIdentification(options:LanguageIdentificationOptions = null):LanguageIdentification {
        if (_languageIdentification != null) {
            _languageIdentification.reinit(options, _isStatsCollectionEnabled);
        } else {
            _languageIdentification = new LanguageIdentification(options, _isStatsCollectionEnabled);
        }
        return _languageIdentification;
    }

    /** The Vision ANE instance. */
    public static function get naturalLanguage():NaturalLanguage {
        if (!_naturalLanguage) {
            new NaturalLanguage();
        }
        return _naturalLanguage;
    }

    /** Disposes the ANE. */
    public static function dispose():void {
        if (LanguageIdentification.context) {
            LanguageIdentification.dispose();
        }
    }

    /**
     * Whether stats collection for the ML Kit Natural Language module is enabled. The stats include API call counts,
     * errors, API call durations, etc. No personally identifiable information is logged. The default value is <code>true</code>.
     */
    public static function get isStatsCollectionEnabled():Boolean {
        return _isStatsCollectionEnabled;
    }

    public static function set isStatsCollectionEnabled(value:Boolean):void {
        _isStatsCollectionEnabled = value;
    }
}
}
