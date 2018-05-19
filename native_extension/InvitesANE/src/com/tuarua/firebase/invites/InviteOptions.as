package com.tuarua.firebase.invites {
public final class InviteOptions {
    public var title:String;
    public var message:String;
    public var deepLink:String;
    public var customImageUrl:String;
    public var action:String;
    public var emailSubject:String;
    public var emailHtmlContent:String;
    public var googleAnalyticsTrackingId:String;
    public var iOSClientID:String;

    public function InviteOptions(title:String) {
        this.title = title;
    }
}
}


