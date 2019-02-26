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

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.firebase.dynamiclinks.FirebaseDynamicLinks
import com.google.gson.Gson
import com.tuarua.firebase.invites.events.InvitesEvent
import com.tuarua.frekotlin.*
import org.greenrobot.eventbus.EventBus
import org.greenrobot.eventbus.Subscribe
import org.greenrobot.eventbus.ThreadMode
import java.util.*
import com.google.firebase.appinvite.FirebaseAppInvite
import com.tuarua.firebase.invites.extensions.InviteIntent


@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val REQUEST_INVITE = 0
    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        EventBus.getDefault().register(this)
        return true.toFREObject()
    }

    fun openInvite(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("openInvite")
        val intent = InviteIntent(argv[0])
        ctx.activity.startActivityForResult(intent, REQUEST_INVITE)
        return null
    }

    fun getDynamicLink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("getDynamicLink")
        val eventId = String(argv[0]) ?: return null
        val appActivity = ctx.activity
        if (appActivity != null) {
            val task = FirebaseDynamicLinks.getInstance().getDynamicLink(appActivity.intent)
            task.addOnSuccessListener {
                val data = it ?: return@addOnSuccessListener
                val link = data.link ?: ""
                val invite = FirebaseAppInvite.getInvitation(data)
                val invitationId = when {
                    invite != null -> invite.invitationId
                    else -> ""
                }
                dispatchEvent(InvitesEvent.ON_LINK,
                        Gson().toJson(
                                InvitesEvent(eventId, mapOf(
                                        "url" to link.toString(),
                                        "invitationId" to invitationId,
                                        "sourceApplication" to "",
                                        "sourceUrl" to "")
                                )
                        ))
            }
            task.addOnFailureListener {
                dispatchEvent(InvitesEvent.ON_LINK, Gson().toJson(
                        InvitesEvent(eventId, error = mapOf(
                                "text" to it.localizedMessage.toString(),
                                "id" to 0))
                ))
            }
        }
        return null
    }

    @Throws(FreException::class)
    @Subscribe(threadMode = ThreadMode.MAIN)
    fun onMessageEvent(event: InvitesEvent) {
        if (_context != null) {
            dispatchEvent(event.eventId, Gson().toJson(InvitesEvent(event.eventId, event.data, event.error)))
        }
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
            FreKotlinLogger.context = _context
        }
}