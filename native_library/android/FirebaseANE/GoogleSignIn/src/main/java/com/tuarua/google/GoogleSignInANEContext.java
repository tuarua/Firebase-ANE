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
package com.tuarua.google;
import com.adobe.air.AndroidActivityWrapper;
import com.adobe.air.TRStateChangeCallback;
import com.tuarua.frekotlin.FreKotlinContext;
import com.tuarua.frekotlin.FreKotlinMainController;
import com.tuarua.google.googlesignin.ResultListener;

import java.util.Objects;
public class GoogleSignInANEContext extends FreKotlinContext {
    private AndroidActivityWrapper aaw;
    private ResultListener resultListener;
    GoogleSignInANEContext(String name, FreKotlinMainController controller, String[] functions) {
        super(name, controller, functions);
        aaw = AndroidActivityWrapper.GetAndroidActivityWrapper();
        resultListener = new ResultListener(Objects.requireNonNull(controller.getContext()));
        aaw.addActivityResultListener(resultListener);
    }

    @Override
    public void dispose() {
        super.dispose();
        if (aaw != null) {
            if (resultListener != null) {
                aaw.removeActivityResultListener(resultListener);
            }
            aaw = null;
        }
    }

}
