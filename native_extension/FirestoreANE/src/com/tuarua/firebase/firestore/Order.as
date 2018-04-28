package com.tuarua.firebase.firestore {
public class Order {
    public var by:String;
    public var descending:Boolean;

    public function Order(by:String, descending:Boolean = false) {
        this.by = by;
        this.descending = descending;
    }
}
}
