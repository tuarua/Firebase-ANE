package views.examples {
import com.tuarua.firebase.InvitesANE;
import com.tuarua.firebase.invites.DynamicLink;
import com.tuarua.firebase.invites.DynamicLinkError;
import com.tuarua.firebase.invites.DynamicLinkResult;
import com.tuarua.firebase.invites.ShortDynamicLinkSuffix;

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
    private var btnCreateDynamicLink:SimpleButton = new SimpleButton("Create Dynamic Link");
    private var btnCreateShortLink:SimpleButton = new SimpleButton("Create Short Link");
    private var btnGetDynamicLink:SimpleButton = new SimpleButton("Get Dynamic Link");
    private var statusLabel:TextField;

    public function InvitesExample(stageWidth:Number) {
        super();
        this.stageWidth = stageWidth;
        initMenu();
    }

    public function initANE():void {
        if (isInited) return;
        invites = InvitesANE.invites;
        isInited = true;
    }

    private function initMenu():void {
        btnGetDynamicLink.x = btnCreateDynamicLink.x = btnCreateShortLink.x = (stageWidth - 200) * 0.5;
        btnCreateDynamicLink.y = StarlingRoot.GAP;
        btnCreateDynamicLink.addEventListener(TouchEvent.TOUCH, onCreateDynamicLinkClick);
        addChild(btnCreateDynamicLink);

        btnCreateShortLink.y = btnCreateDynamicLink.y + StarlingRoot.GAP;
        btnCreateShortLink.addEventListener(TouchEvent.TOUCH, onCreateShortLinkClick);
        addChild(btnCreateShortLink);

        btnGetDynamicLink.y = btnCreateShortLink.y + StarlingRoot.GAP;
        btnGetDynamicLink.addEventListener(TouchEvent.TOUCH, onGetDynamicLinkClick);
        addChild(btnGetDynamicLink);

        statusLabel = new TextField(stageWidth, 1400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnGetDynamicLink.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);
    }

    private function onCreateDynamicLinkClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCreateDynamicLink);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var dynamicLink:DynamicLink = new DynamicLink("http://www.tuarua.com", "fq7yh.app.goo.gl");
            invites.buildDynamicLink(dynamicLink, onDynamicLinkCreated);
        }
    }

    private function onDynamicLinkCreated(dynamicLinkResult:DynamicLinkResult, error:DynamicLinkError):void {
        if (error) {
            statusLabel.text = "Dynamic Link error: " + error.errorID + " : " + error.message;
            return;
        }
        if(dynamicLinkResult.url){
            statusLabel.text = dynamicLinkResult.url;
        } else {
            statusLabel.text = dynamicLinkResult.previewLink + "\n" +
                    dynamicLinkResult.shortLink + "\n" +
                    dynamicLinkResult.warnings.toString();
        }

    }

    private function onCreateShortLinkClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnCreateShortLink);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var shortLink:DynamicLink = new DynamicLink("http://www.github.com", "fq7yh.app.goo.gl");
            invites.buildDynamicLink(shortLink, onDynamicLinkCreated, true, ShortDynamicLinkSuffix.SHORT);
        }
    }

    private function onGetDynamicLinkClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetDynamicLink);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            invites.getDynamicLink(onGetDynamicLink);
        }
    }

    private function onGetDynamicLink():void {

    }

}
}
