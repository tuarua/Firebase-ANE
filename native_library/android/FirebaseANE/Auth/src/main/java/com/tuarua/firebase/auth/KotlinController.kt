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
package com.tuarua.firebase.auth

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*
import java.util.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var authController: AuthController
    private lateinit var userController: UserController

    fun createGUID(ctx: FREContext, argv: FREArgv): FREObject? {
        return UUID.randomUUID().toString().toFREObject()
    }

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        authController = AuthController(context)
        userController = UserController(context)
        return true.toFREObject()
    }

    fun getCurrentUser(ctx: FREContext, argv: FREArgv): FREObject? {
        return userController.currentUser?.toFREObject()
    }

    fun getIdToken(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("getIdToken")
        val forceRefresh = Boolean(argv[0]) ?: return FreConversionException("forceRefresh")
        val eventId = String(argv[1]) ?: return FreConversionException("eventId")
        userController.getIdToken(forceRefresh, eventId)
        return null
    }

    fun createUserWithEmailAndPassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("createUserWithEmailAndPassword")
        val email = String(argv[0]) ?: return FreConversionException("email")
        val password = String(argv[1]) ?: return FreConversionException("password")
        val eventId = String(argv[2])
        authController.createUserWithEmailAndPassword(email, password, eventId)
        return null
    }

    fun signInWithEmailAndPassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("signInWithEmailAndPassword")
        val email = String(argv[0]) ?: return FreConversionException("email")
        val password = String(argv[1]) ?: return FreConversionException("password")
        val eventId = String(argv[2])
        authController.signInWithEmailAndPassword(email, password, eventId)
        return null
    }

    fun signInAnonymously(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("signInAnonymously")
        val eventId = String(argv[0])
        authController.signInAnonymously(eventId)
        return null
    }

    fun updateProfile(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 2 } ?: return FreArgException("updateProfile")
        val displayName = String(argv[0])
        val photoUrl = String(argv[1])
        val eventId = String(argv[2])
        userController.updateProfile(displayName, photoUrl, eventId)
        return null
    }

    fun signOut(ctx: FREContext, argv: FREArgv): FREObject? {
        authController.signOut()
        return null
    }

    fun reload(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("reload")
        val eventId = String(argv[0])
        userController.reload(eventId)
        return null
    }

    fun sendEmailVerification(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("sendEmailVerification")
        val eventId = String(argv[0])
        userController.sendEmailVerification(eventId)
        return null
    }

    fun updateEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("updateEmail")
        val email = String(argv[0]) ?: return FreConversionException("email")
        val eventId = String(argv[1])
        userController.updateEmail(email, eventId)
        return null
    }

    fun updatePassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("updatePassword")
        val password = String(argv[0]) ?: return FreConversionException("password")
        val eventId = String(argv[1])
        userController.updatePassword(password, eventId)
        return null
    }

    fun sendPasswordResetEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("sendPasswordResetEmail")
        val email = String(argv[0]) ?: return FreConversionException("email")
        val eventId = String(argv[1])
        authController.sendPasswordResetEmail(email, eventId)
        return null
    }

    fun deleteUser(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("deleteUser")
        val eventId = String(argv[0])
        userController.deleteUser(eventId)
        return null
    }

    fun reauthenticate(ctx: FREContext, argv: FREArgv): FREObject? { //this is by email
        argv.takeIf { argv.size > 2 } ?: return FreArgException("init")
        val email = String(argv[0]) ?: return FreConversionException("email")
        val password = String(argv[1]) ?: return FreConversionException("password")
        val eventId = String(argv[2])
        userController.reauthenticate(email, password, eventId)
        return null
    }

    fun unlink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return FreArgException("unlink")
        val provider = String(argv[0]) ?: return FreConversionException("provider")
        val eventId = String(argv[1])
        userController.unlink(provider, eventId)
        return null
    }

    fun setLanguageCode(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return FreArgException("setLanguageCode")
        val code = String(argv[0]) ?: return FreConversionException("code")
        authController.setLanguageCode(code)
        return null
    }

    fun getLanguageCode(ctx: FREContext, argv: FREArgv): FREObject? {
        return authController.languageCode?.toFREObject()
    }

    override val TAG: String
        get() = this::class.java.canonicalName
    private var _context: FREContext? = null
    override var context: FREContext?
        get() = _context
        set(value) {
            _context = value
        }
}