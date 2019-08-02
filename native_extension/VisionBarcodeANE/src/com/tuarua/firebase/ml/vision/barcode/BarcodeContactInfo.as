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

package com.tuarua.firebase.ml.vision.barcode {

[RemoteClass(alias="com.tuarua.firebase.ml.vision.barcode.BarcodeContactInfo")]
/**
 * A person's or organization's business card. For example, a vCard.
 */
public class BarcodeContactInfo {
    /**
     * A job title.
     */
    public var jobTitle:String;
    /**
     * A person's name.
     */
    public var name:String;
    /**
     * A business organization.
     */
    public var organization:String;
    /**
     * Person's or organization's addresses.
     */
    public var addresses:Vector.<BarcodeAddress> = new <BarcodeAddress>[];
    /**
     * Contact emails.
     */
    public var emails:Vector.<BarcodeEmail> = new <BarcodeEmail>[];
    /**
     * Contact phone numbers.
     */
    public var phones:Vector.<BarcodePhone> = new <BarcodePhone>[];
    /**
     * Contact URLs.
     */
    public var urls:Vector.<String> = new <String>[];
    /** @private */
    public function BarcodeContactInfo() {
    }
}
}