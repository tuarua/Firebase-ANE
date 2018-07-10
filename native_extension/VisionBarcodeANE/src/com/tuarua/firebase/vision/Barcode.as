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

import flash.geom.Point;
import flash.geom.Rectangle;

public class Barcode {
    public var frame:Rectangle;
    public var rawValue:String;
    public var displayValue:String;
    public var format:int;
    public var cornerPoints:Vector.<Point> = new <Point>[];
    public var valueType:int;
    public var email:BarcodeEmail;
    public var phone:BarcodePhone;
    public var sms:BarcodeSMS;
    public var url:BarcodeURLBookmark;
    public var wifi:BarcodeWifi;
    public var geoPoint:BarcodeGeoPoint;
    public var contactInfo:BarcodeContactInfo;
    public var driverLicense:BarcodeDriverLicense;
    public var calendarEvent:BarcodeCalendarEvent;

    public function Barcode() {
    }
}
}