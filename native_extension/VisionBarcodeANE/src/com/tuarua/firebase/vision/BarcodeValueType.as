package com.tuarua.firebase.vision {
public final class BarcodeValueType {
    /**
     * Unknown Barcode value types.
     */
    public static const unknown:int = 0;
    /**
     * Barcode value type for contact info.
     */
    public static const contactInfo:int = 1;
    /**
     * Barcode value type for email addresses.
     */
    public static const email:int = 2;
    /**
     * Barcode value type for ISBNs.
     */
    public static const ISBN:int = 3;
    /**
     * Barcode value type for phone numbers.
     */
    public static const phone:int = 4;
    /**
     * Barcode value type for product codes.
     */
    public static const product:int = 5;
    /**
     * Barcode value type for SMS details.
     */
    public static const SMS:int = 6;
    /**
     * Barcode value type for plain text.
     */
    public static const text:int = 7;
    /**
     * Barcode value type for URLs/bookmarks.
     */
    public static const url:int = 8;
    /**
     * Barcode value type for Wi-Fi access point details.
     */
    public static const wifi:int = 9;
    /**
     * Barcode value type for geographic coordinates.
     */
    public static const geographicCoordinates:int = 10;
    /**
     * Barcode value type for calendar events.
     */
    public static const calendarEvent:int = 11;
    /**
     * Barcode value type for driver's license data.
     */
    public static const driversLicense:int = 12;

    public static function toString(value:int):String {
        switch (value) {
            case 0:
                return "unknown";
            case 1:
                return "contactInfo";
            case 2:
                return "email";
            case 3:
                return "ISBN";
            case 4:
                return "phone";
            case 5:
                return "product";
            case 6:
                return "SMS";
            case 7:
                return "text";
            case 8:
                return "url";
            case 9:
                return "wifi";
            case 10:
                return "geographicCoordinates";
            case 11:
                return "calendarEvent";
            case 12:
                return "driversLicense";
            default:
                return "unknown";
        }
    }
}
}
