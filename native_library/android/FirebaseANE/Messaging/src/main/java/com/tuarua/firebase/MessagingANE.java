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
package com.tuarua.firebase;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.tuarua.firebase.messaging.KotlinController;

@SuppressWarnings("unused")
public class MessagingANE implements FREExtension {
    private static final String[] FUNCTIONS = {
            "init"
            ,"createGUID"
            ,"getToken"
            ,"subscribe"
            ,"unsubscribe"
    };

    private static MessagingANEContext extensionContext;

    @Override
    public void initialize() {

    }

    @Override
    public FREContext createContext(String s) {
        String NAME = "com.tuarua.firebase.MessagingANE";
        return extensionContext = new MessagingANEContext(NAME, new KotlinController(), FUNCTIONS);
    }

    @Override
    public void dispose() {
        extensionContext.dispose();
    }
}
