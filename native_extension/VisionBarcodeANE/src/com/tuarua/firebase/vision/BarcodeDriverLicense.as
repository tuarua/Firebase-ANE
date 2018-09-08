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
[RemoteClass(alias="com.tuarua.firebase.vision.BarcodeDriverLicense")]
public class BarcodeDriverLicense {
    /**
     * Driver license expiration date. The date format depends on the issuing country.
     */
    public var expiryDate:String;
    /**
     * Holder's first name.
     */
    public var firstName:String;
    /**
     * Holder's gender. 1 is male and 2 is female.
     */
    public var gender:String;
    /**
     * A country in which DL/ID was issued.
     */
    public var issuingCountry:String;
    /**
     * The date format depends on the issuing country.
     */
    public var issuingDate:String;
    /**
     * Holder's last name.
     */
    public var lastName:String;
    /**
     * Driver license ID number.
     */
    public var licenseNumber:String;
    /**
     * Holder's middle name.
     */
    public var middleName:String;
    /** @private */
    public function BarcodeDriverLicense() {
    }
}
}