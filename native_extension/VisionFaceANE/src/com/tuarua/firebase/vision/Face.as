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
package com.tuarua.firebase.vision {
import flash.geom.Rectangle;

[RemoteClass(alias="com.tuarua.firebase.vision.Face")]
/**
 * A human face detected in an image.
 */
public class Face {
    /**
     * The rectangle that holds the discovered relative to the detected image in the view
     * coordinate system.
     */
    public var frame:Rectangle;
    /**
     * Indicates whether the face has a tracking ID.
     */
    public var hasTrackingId:Boolean = false;
    /**
     * Indicates whether the detector found the head y euler angle.
     */
    public var hasHeadEulerAngleY:Boolean = false;
    /**
     * Indicates whether the detector found the head z euler angle.
     */
    public var hasHeadEulerAngleZ:Boolean = false;
    /**
     * Indicates the rotation of the face about the vertical axis of the image.  Positive y euler angle
     * is when the face is turned towards the right side of the image that is being processed.
     */
    public var headEulerAngleY:Number;
    /**
     * Indicates the rotation of the face about the axis pointing out of the image.  Positive z euler
     * angle is a counter-clockwise rotation within the image plane.
     */
    public var headEulerAngleZ:Number;
    /**
     * Indicates whether a smiling probability is available.
     */
    public var hasSmilingProbability:Boolean = false;
    /**
     * Indicates whether a left eye open probability is available.
     */
    public var hasLeftEyeOpenProbability:Boolean = false;
    /**
     * Indicates whether a right eye open probability is available.
     */
    public var hasRightEyeOpenProbability:Boolean = false;
    /**
     * The tracking identifier of the face.
     */
    public var trackingId:int;
    /**
     * Probability that the face is smiling.
     */
    public var smilingProbability:Number;
    /**
     * Probability that the face's left eye is open.
     */
    public var leftEyeOpenProbability:Number;
    /**
     * Probability that the face's right eye is open.
     */
    public var rightEyeOpenProbability:Number;

    /**
     * All the landmarks.
     */
    public var landmarks:Vector.<FaceLandmark> = new <FaceLandmark>[];

    /** @private */
    public function Face() {
    }
    /**
     * Returns the landmark, if any, of the given type in this detected face.
     *
     * @param ofType The type of the facial landmark.
     * @return The landmark of the given type in this face.  nil if there isn't one.
     */
    public function landmark(ofType:String):FaceLandmark {
        for each (var landmark:FaceLandmark in landmarks) {
            if(landmark.type == ofType){
                return landmark;
            }
        }
        return null;
    }
}
}