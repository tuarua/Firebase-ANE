package com.tuarua.firebase.invites {
public final class InviteOptions {
    /** <p>Sets the title of the invite.</p> */
    public var title:String;
    /** <p>Sets the invite message that is sent to all invitees.</p> */
    public var message:String;
    /** <p>Sets the deep link that is made available to the app when opened from the invitation.</p> */
    public var deepLink:String;
    /** <p>Sets an image for invitations.</p> */
    public var customImageUrl:String;
    /** <p>Text shown on the email invitation for the user to accept the invitation.</p> */
    public var action:String;
    /** <p>Sets the subject for invites sent by email.</p> */
    public var emailSubject:String;
    /** <p>Sets the HTML-formatted (UTF-8 encoded, no JavaScript) content for invites sent through email.</p> */
    public var emailHtmlContent:String;
    /** <p>Sets the Google Analytics Tracking id.</p> */
    public var googleAnalyticsTrackingId:String;
    /** <p>Targets another version of your app to receive the invitation from Android.</p> */
    public var iOSClientID:String;

    public function InviteOptions(title:String) {
        this.title = title;
    }
}
}


