/*
 * Copyright 2018 Tua Rua Ltd.
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

package com.tuarua.frenative

import android.animation.ObjectAnimator
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.drawable.BitmapDrawable
import android.view.View
import android.widget.FrameLayout
import android.widget.ImageButton
import com.adobe.fre.FREContext
import com.adobe.fre.FREObject
import com.google.gson.Gson
import com.tuarua.frekotlin.display.Bitmap
import com.tuarua.frekotlin.*

@Suppress("unused")
@SuppressLint("ViewConstructor")
class FreNativeButton(applicationContext: Context,
                      context: FREContext?,
                      freObject: FREObject,
                      id: String,
                      private val scaleFactor: Float) : ImageButton(applicationContext) {
    init {
        val bmp = Bitmap(freObject["bitmapData"], true)
        if (bmp != null) {
            this.background = BitmapDrawable(applicationContext.resources, bmp)
            this.alpha = Float(freObject["alpha"]) ?: 1.0f
            this.x = Float(freObject["x"])?.times(scaleFactor) ?: 0f
            this.y = Float(freObject["y"])?.times(scaleFactor) ?: 0f
            this.visibility = if (Boolean(freObject["visible"]) != false) View.VISIBLE else View.INVISIBLE
            this.layoutParams = FrameLayout.LayoutParams(bmp.width, bmp.height)
            this.isClickable = true
            this.setOnClickListener {
                context?.dispatchEvent("NativeButtonEvent",
                        Gson().toJson(mapOf("id" to id, "event" to "click")))
            }
        }
    }

    fun update(prop: FREObject, value: FREObject) {
        val propName = String(prop) ?: return
        when (propName) {
            "x" -> this.x = Float(value)?.times(scaleFactor) ?: 0.0f
            "y" -> this.y = Float(value)?.times(scaleFactor) ?: 0.0f
            "alpha" -> this.alpha = Float(value) ?: 1.0f
            "visible" -> {
                this.visibility = if (Boolean(value) != false) View.VISIBLE else View.INVISIBLE
            }
        }
        this.invalidate()
    }

    fun animateProp(prop: FREObject, value: FREObject, duration: FREObject) {
        val propName = String(prop) ?: return
        if (propName != "x" && propName != "y" && propName != "alpha") return
        val dur = Long(duration) ?: return
        var v = Float(value) ?: return
        when (propName) {
            "x", "y" -> v = v.times(scaleFactor)
        }
        this.animation.reset()
        val anim = ObjectAnimator.ofFloat(this, propName, v)
        anim.duration = dur
        anim.start()
    }

//    @SuppressLint("ClickableViewAccessibility")
//    override fun performClick(): Boolean {
//        return true
//    }

}