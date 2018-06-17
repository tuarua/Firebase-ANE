package views.examples {
import com.tuarua.firebase.InvitesANE;
import com.tuarua.firebase.invites.Invite;
import com.tuarua.firebase.invites.DynamicLinkError;
import com.tuarua.firebase.invites.DynamicLinkResult;
import com.tuarua.firebase.invites.events.InvitesEvent;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class InvitesExample extends Sprite implements IExample {
    private var stageWidth:Number;
    private var isInited:Boolean;
    private var invites:InvitesANE;
    private var btnOpenInvite:SimpleButton = new SimpleButton("Open Invite");
    private var btnGetDynamicLink:SimpleButton = new SimpleButton("Get Dynamic Link");
    private var statusLabel:TextField;

    public function InvitesExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    private function initMenu():void {
        btnGetDynamicLink.x = btnOpenInvite.x = (stageWidth - 200) * 0.5;
        btnOpenInvite.y = StarlingRoot.GAP;
        btnOpenInvite.addEventListener(TouchEvent.TOUCH, onOpenInviteClick);
        addChild(btnOpenInvite);

        btnGetDynamicLink.y = btnOpenInvite.y + StarlingRoot.GAP;
        btnGetDynamicLink.addEventListener(TouchEvent.TOUCH, onGetDynamicLinkClick);
        addChild(btnGetDynamicLink);

        statusLabel = new TextField(stageWidth, 1400, "Ensure you are logged in to your Google account. Use Auth Menu");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnGetDynamicLink.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);
    }

    private function onOpenInviteClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnOpenInvite);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var invite:Invite = new Invite("5 Dollar offer", "Messy Message");
            invite.deepLink = "http://example.com/offer/five_dollar_offer";
            invite.open();
        }
    }

    private function onGetDynamicLinkClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetDynamicLink);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            invites.getDynamicLink(onGetDynamicLink);
        }
    }

    private function onGetDynamicLink(dynamicLinkResult:DynamicLinkResult, error:DynamicLinkError):void {
        if (error) {
            statusLabel.text = "Dynamic Link error: " + error.errorID + " : " + error.message;
            return;
        }
        statusLabel.text = "Invitation Link: " + dynamicLinkResult.url
                + "\nInvitation Id: " + dynamicLinkResult.invitationId;
    }

    public function initANE():void {
        if (isInited) return;
        invites = InvitesANE.invites;
        invites.addEventListener(InvitesEvent.SUCCESS, onInviteSent);
        invites.addEventListener(InvitesEvent.ERROR, onInviteSendError);
        isInited = true;
    }

    private function onInviteSent(event:InvitesEvent):void {
        statusLabel.text = "";
        for each (var id:String in event.ids) {
            statusLabel.text += "Invite sent to: " + id;
        }
    }

    private function onInviteSendError(event:InvitesEvent):void {
        if (event.error) {
            statusLabel.text = "Invites error: " + event.error.errorID + " : " + event.error.message;
        }
    }


}
}
