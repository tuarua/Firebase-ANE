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

package com.tuarua.firebase.invites

import android.app.Activity.RESULT_OK
import android.content.Intent
import com.adobe.air.FreKotlinActivityResultCallback
import com.adobe.fre.FREContext
import com.tuarua.frekotlin.FreKotlinController
import com.google.android.gms.appinvite.AppInviteInvitation
import com.tuarua.firebase.invites.events.InvitesEvent
import org.greenrobot.eventbus.EventBus

class ResultListener(override var context: FREContext?) : FreKotlinController,
        FreKotlinActivityResultCallback {
    override fun onActivityResult(requestCode: Int, resultCode: Int, intent: Intent?) {
        if (requestCode == REQUEST_INVITE) {
            if (resultCode == RESULT_OK) {
                val data = intent ?: return
                val ids = AppInviteInvitation.getInvitationIds(resultCode, data)
                val idsArr = mutableListOf<String>()
                for (id in ids) {
                    idsArr.add(id)
                }
                EventBus.getDefault().post(InvitesEvent(InvitesEvent.SUCCESS,
                        mapOf("ids" to idsArr))
                )
            } else {
                EventBus.getDefault().post(InvitesEvent(InvitesEvent.ERROR,
                        error = mapOf("text" to "",
                                "id" to resultCode))
                )
            }

        }
    }

    companion object {
        const val REQUEST_INVITE = 0
    }

    override val TAG: String?
        get() = this::class.java.simpleName
}