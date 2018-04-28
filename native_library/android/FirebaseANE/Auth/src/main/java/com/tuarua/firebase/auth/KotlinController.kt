package com.tuarua.firebase.auth

import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.tuarua.frekotlin.*

@Suppress("unused", "UNUSED_PARAMETER", "UNCHECKED_CAST", "PrivatePropertyName")
class KotlinController : FreKotlinMainController {
    private val TRACE = "TRACE"
    private lateinit var authController: AuthController
    private lateinit var userController: UserController

    fun init(ctx: FREContext, argv: FREArgv): FREObject? {
        authController = AuthController(context)
        userController = UserController(context)
        return true.toFREObject()
    }

    fun getCurrentUser(ctx: FREContext, argv: FREArgv): FREObject? {
        val currentUser = userController.currentUser
        if (currentUser != null) try {
            return FREObject("com.tuarua.firebase.auth.FirebaseUser",
                    currentUser.uid,
                    currentUser.displayName,
                    currentUser.email,
                    currentUser.isAnonymous,
                    currentUser.isEmailVerified,
                    currentUser.photoUrl,
                    currentUser.phoneNumber
            )


            //email:String, isAnonymous:Boolean, isEmailVerified:Boolean,
            //photoUrl:String, phoneNumber:String

            /*ret.setProp("uid", currentUser.uid)
            ret.setProp("displayName", currentUser.displayName)
            ret.setProp("email", currentUser.email)
            ret.setProp("isAnonymous", currentUser.isAnonymous)
            ret.setProp("isEmailVerified", currentUser.isEmailVerified)
            ret.setProp("photoUrl", currentUser.photoUrl)
            ret.setProp("phoneNumber", currentUser.phoneNumber)*/
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun getIdToken(ctx: FREContext, argv: FREArgv): FREObject? { //TODO
        return null
    }

    fun createUserWithEmailAndPassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val email = String(argv[0])
            val password = String(argv[1])
            if (email != null && password != null) {
                authController.createUserWithEmailAndPassword(email, password)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun signInWithEmailAndPassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val email = String(argv[0])
            val password = String(argv[1])
            if (email != null && password != null) {
                authController.signInWithEmailAndPassword(email, password)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }


    fun updateProfile(ctx: FREContext, argv: FREArgv): FREObject? {
        return null
    }

    fun signOut(ctx: FREContext, argv: FREArgv): FREObject? {
        authController.signOut()
        return null
    }

    fun sendEmailVerification(ctx: FREContext, argv: FREArgv): FREObject? {
        userController.sendEmailVerification()
        return null
    }

    fun updateEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val email = String(argv[0])
            if (email != null) {
                userController.updateEmail(email)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun updatePassword(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val password = String(argv[0])
            if (password != null) {
                userController.updatePassword(password)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun sendPasswordResetEmail(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val email = String(argv[0])
            if (email != null) {
                authController.sendPasswordResetEmail(email)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun deleteUser(ctx: FREContext, argv: FREArgv): FREObject? {
        authController.deleteUser()
        return null
    }

    fun reauthenticate(ctx: FREContext, argv: FREArgv): FREObject? { //this is by email
        argv.takeIf { argv.size > 1 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val email = String(argv[0])
            val password = String(argv[1])
            if (email != null && password != null) {
                authController.reauthenticate(email, password)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }

    fun unlink(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 1 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val provider = String(argv[0])
            if (provider != null) {
                userController.unlink(provider)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
        return null
    }


    fun signInAnonymously(ctx: FREContext, argv: FREArgv): FREObject? {
        authController.signInAnonymously()
        return null
    }

    fun setLanguageCode(ctx: FREContext, argv: FREArgv): FREObject? {
        argv.takeIf { argv.size > 0 } ?: return ArgCountException().getError(Thread.currentThread().stackTrace)
        try {
            val code = String(argv[0])
            if (code != null) {
                authController.setLanguageCode(code)
            }else{
                return NullArgsException().getError(Thread.currentThread().stackTrace)
            }
        } catch (e: FreException) {
            return e.getError(Thread.currentThread().stackTrace)
        } catch (e: Exception) {
            return FreException(e).getError(Thread.currentThread().stackTrace)
        }
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