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

import androidx.annotation.NonNull;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.tuarua.firebase.auth.KotlinController;

@SuppressWarnings({"unused"})
public class AuthANE implements FREExtension {
    private static final String[] FUNCTIONS = {
            "init"
            ,"createGUID"
            ,"createUserWithEmailAndPassword"
            ,"signInWithCredential"
            ,"signInWithProvider"
            ,"signInAnonymously"
            ,"signInWithCustomToken"
            ,"updateProfile"
            ,"signOut"
            ,"sendEmailVerification"
            ,"updateEmail"
            ,"updatePassword"
            ,"sendPasswordResetEmail"
            ,"deleteUser"
            ,"reauthenticateWithCredential"
            ,"reauthenticateWithProvider"
            ,"unlink"
            ,"link"
            ,"setLanguageCode"
            ,"getLanguageCode"
            ,"getCurrentUser"
            ,"getIdToken"
            ,"reload"
            ,"verifyPhoneNumber"
    };

    private static AuthANEContext extensionContext;

    @Override
    public void initialize() {

    }

    @NonNull
    @Override
    public FREContext createContext(@NonNull String s) {
        String NAME = "com.tuarua.firebase.AuthANE";
        return extensionContext = new AuthANEContext(NAME, new KotlinController(), FUNCTIONS);
    }

    @Override
    public void dispose() {
        extensionContext.dispose();
    }
}
