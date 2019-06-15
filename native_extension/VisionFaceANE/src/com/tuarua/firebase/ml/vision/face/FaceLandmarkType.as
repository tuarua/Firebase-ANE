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
package com.tuarua.firebase.ml.vision.face {
public final class FaceLandmarkType {
    /** Midpoint of the left ear tip and left ear lobe. */
    public static const leftEar:String = "LeftEar";
    /** Midpoint of the right ear tip and right ear lobe. */
    public static const rightEar:String = "RightEar";
    /** Left eye. */
    public static const leftEye:String = "LeftEye";
    /** Right eye. */
    public static const rightEye:String = "RightEye";
    /** Center of the bottom lip. */
    public static const mouthBottom:String = "MouthBottom";
    /** Right corner of the mouth */
    public static const mouthRight:String = "MouthRight";
    /** Left corner of the mouth */
    public static const mouthLeft:String = "MouthLeft";
    /** Left cheek. */
    public static const leftCheek:String = "LeftCheek";
    /** Right cheek. */
    public static const rightCheek:String = "RightCheek";
    /** Midpoint between the nostrils where the nose meets the face. */
    public static const noseBase:String = "NoseBase";
}
}