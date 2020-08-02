/*
 * Copyright 2020 Tua Rua Ltd.
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

package com.tuarua.mlkit.vision.barcode {

import flash.geom.Point;
import flash.geom.Rectangle;

[RemoteClass(alias="com.tuarua.mlkit.vision.barcode.Barcode")]
public class Barcode {
    /** The rectangle that holds the discovered relative to the detected image in the view coordinate system. */
    public var frame:Rectangle;
    /**
     * <p>A barcode value as it was encoded in the barcode. Structured values are not parsed, for example:<br>
     * 'MEBKM:TITLE:Google;URL:https://www.google.com;;'. Does not include the supplemental value.</p>
     */
    public var rawValue:String;
    /**
     * <p>A barcode value in a user-friendly format. May omit some of the information encoded in the<br>
     * barcode. For example, in the case above the display value might be 'https://www.google.com'.<br>
     * If valueType == .text, this field will be equal to rawValue. This value may be multiline,<br>
     * for example, when line breaks are encoded into the original TEXT barcode value. May include<br>
     * the supplement value.</p>
     */
    public var displayValue:String;
    /**
     * <p>A barcode format; for example, EAN_13. Note that if the format is not in the list,<br>
     * VisionBarcodeFormat.unknown would be returned.</p>
     */
    public var format:int;
    /**
     * <p>The four corner points of the barcode, in clockwise order starting with the top left relative<br>
     * to the detected image in the view coordinate system. These are <code>flash.geom.Point</code> boxed in values.<br>
     * Due to the possible perspective distortions, this is not necessarily a rectangle.</p>
     */
    public var cornerPoints:Vector.<Point> = new <Point>[];
    /**
     * <p>A type of the barcode value. For example, TEXT, PRODUCT, URL, etc. Note that if the type is not<br>
     * in the list, .unknown would be returned.</p>
     */
    public var valueType:int;
    /**
     * <p>An email message from a 'MAILTO:' or similar QR Code type. This property is only set if<br>
     * valueType is .email.</p>
     */
    public var email:BarcodeEmail;
    /**
     * <p>A phone number from a 'TEL:' or similar QR Code type. This property is only set if valueType<br>
     * is .phone.</p>
     */
    public var phone:BarcodePhone;
    /**
     * <p>An SMS message from an 'SMS:' or similar QR Code type. This property is only set if valueType<br>
     * is .sms.</p>
     */
    public var sms:BarcodeSMS;
    /**
     * <p>A URL and title from a 'MEBKM:' or similar QR Code type. This property is only set if<br>
     * valueType is .url.</p>
     */
    public var url:BarcodeURLBookmark;
    /**
     * <p>Wi-Fi network parameters from a 'WIFI:' or similar QR Code type. This property is only set<br>
     * if valueType is .wifi.</p>
     */
    public var wifi:BarcodeWifi;
    /**
     * <p>GPS coordinates from a 'GEO:' or similar QR Code type. This property is only set if valueType<br>
     * is .geo.</p>
     */
    public var geoPoint:BarcodeGeoPoint;
    /**
     * <p>A person's or organization's business card. For example a VCARD. This property is only set<br>
     * if valueType is .contactInfo.</p>
     */
    public var contactInfo:BarcodeContactInfo;
    /**
     * <p>A driver license or ID card. This property is only set if valueType is .driverLicense.</p>
     */
    public var driverLicense:BarcodeDriverLicense;
    /**
     * <p>A calendar event extracted from a QR Code. This property is only set if valueType is<br>
     * .calendarEvent.</p>
     */
    public var calendarEvent:BarcodeCalendarEvent;

    /** private */
    public function Barcode() {
    }
}
}