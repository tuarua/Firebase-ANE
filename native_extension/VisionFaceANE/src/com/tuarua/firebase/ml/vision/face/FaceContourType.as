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
/** Facial contour types.*/
public final class FaceContourType {
    /** A set of points that outline the face oval. */
    public static const face:String = "Face";
    /** A set of points that outline the top of the left eyebrow. */
    public static const leftEyebrowTop:String = "LeftEyebrowTop";
    /** A set of points that outline the bottom of the left eyebrow. */
    public static const leftEyebrowBottom:String = "LeftEyebrowBottom";
    /** A set of points that outline the top of the right eyebrow. */
    public static const rightEyebrowTop:String = "RightEyebrowTop";
    /** A set of points that outline the bottom of the right eyebrow. */
    public static const rightEyebrowBottom:String = "RightEyebrowBottom";
    /** A set of points that outline the left eye. */
    public static const leftEye:String = "LeftEye";
    /** A set of points that outline the right eye. */
    public static const rightEye:String = "RightEye";
    /** A set of points that outline the top of the upper lip. */
    public static const upperLipTop:String = "UpperLipTop";
    /** A set of points that outline the bottom of the upper lip. */
    public static const upperLipBottom:String = "UpperLipBottom";
    /** A set of points that outline the top of the lower lip. */
    public static const lowerLipTop:String = "LowerLipTop";
    /** A set of points that outline the bottom of the lower lip. */
    public static const lowerLipBottom:String = "LowerLipBottom";
    /** A set of points that outline the nose bridge. */
    public static const noseBridge:String = "NoseBridge";
    /** A set of points that outline the bottom of the nose. */
    public static const noseBottom:String = "NoseBottom";
}
}
