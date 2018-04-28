@file:Suppress("FunctionName")

package com.tuarua.firebase.firestore

import com.adobe.fre.FREObject
import com.tuarua.frekotlin.FreException
import com.tuarua.frekotlin.setProp

@Throws(FreException::class)
//only handles String, Double, Int, Long, FREObject, Short, Boolean, Date
fun FREObject(name: String, mapFrom: Map<String, Any>): FREObject? {
    val argsArr = arrayOfNulls<FREObject>(0)
    return try {
        val v = FREObject.newObject(name, argsArr)
        for (k in mapFrom.keys) {
            v.setProp(k, mapFrom[k])
        }
        v
    } catch (e: FreException) {
        e.getError(Thread.currentThread().stackTrace)
    } catch (e: Exception) {
        throw FreException(e, "cannot create new object named $name")
    }
}