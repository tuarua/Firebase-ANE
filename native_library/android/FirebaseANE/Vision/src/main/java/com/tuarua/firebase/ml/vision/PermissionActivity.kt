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

package com.tuarua.firebase.ml.vision

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.view.View
import com.tuarua.firebase.ml.vision.events.PermissionEvent
import org.greenrobot.eventbus.EventBus

class PermissionActivity : Activity(), ActivityCompat.OnRequestPermissionsResultCallback {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val decorView = window.decorView
        val uiOptions = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or View.SYSTEM_UI_FLAG_FULLSCREEN
        decorView.systemUiVisibility = uiOptions

        val extras = intent.extras ?: return
        val permissions = extras.getStringArray("ptc") ?: return
        ActivityCompat.requestPermissions(this, permissions, 19001)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        if (requestCode == 19001) {
            for ((index, permission) in permissions.withIndex()) {
                if (grantResults[index] == PackageManager.PERMISSION_GRANTED) {
                    EventBus.getDefault().post(PermissionEvent(permission, PermissionEvent.PERMISSION_ALWAYS))
                } else {
                    if (ActivityCompat.shouldShowRequestPermissionRationale(this, permission)) {
                        EventBus.getDefault().post(PermissionEvent(permission, PermissionEvent.PERMISSION_SHOW_RATIONALE))
                    } else {
                        EventBus.getDefault().post(PermissionEvent(permission, PermissionEvent.PERMISSION_DENIED))
                    }
                }
            }
        }
        finish()
    }
}
