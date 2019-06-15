package views.examples {

import com.tuarua.firebase.ml.naturallanguage.LanguageIdentificationError;
import com.tuarua.firebase.ml.naturallanguage.NaturalLanguageANE;
import com.tuarua.firebase.ml.naturallanguage.languageid.IdentifiedLanguage;
import com.tuarua.firebase.ml.naturallanguage.languageid.LanguageIdentification;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class NaturalLanguageExample extends Sprite implements IExample {
    private var btnLanguage:SimpleButton = new SimpleButton("Detect Language");
    private var btnPossibleLanguages:SimpleButton = new SimpleButton("Detect Possible Languages");
    private var textContainer:Sprite = new Sprite();
    private var statusLabel:TextField;
    private var stageWidth:Number;
    private var stageHeight:Number;
    private var isInited:Boolean;
    private var naturalLanguage:NaturalLanguageANE;
    private var languageIdentification:LanguageIdentification;

    public function NaturalLanguageExample(stageWidth:int, naturalLanguage:NaturalLanguageANE) {
        super();
        this.naturalLanguage = naturalLanguage;
        this.stageWidth = stageWidth;
        this.stageHeight = stageHeight;
        initMenu();
    }

    private function initMenu():void {
        btnPossibleLanguages.x = btnLanguage.x = (stageWidth - 200) * 0.5;

        btnLanguage.y = StarlingRoot.GAP;
        btnLanguage.addEventListener(TouchEvent.TOUCH, OnLanguageClick);
        addChild(btnLanguage);

        btnPossibleLanguages.y = btnLanguage.y + StarlingRoot.GAP;
        btnPossibleLanguages.addEventListener(TouchEvent.TOUCH, OnPossibleLanguagesClick);
        addChild(btnPossibleLanguages);

        statusLabel = new TextField(stageWidth, 100, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnPossibleLanguages.y + (StarlingRoot.GAP * 1.25);
        addChild(statusLabel);

        var newScale:Number = (stageWidth - 30) / textContainer.width;
        textContainer.scaleY = textContainer.scaleX = newScale;

        textContainer.x = (stageWidth - textContainer.width) * 0.5;
        textContainer.y = statusLabel.y + StarlingRoot.GAP;

        addChild(textContainer);
    }

    public function initANE():void {
        if (isInited) return;
        // make sure to package alangid_model.smfb.jpg with app for Android
        languageIdentification = naturalLanguage.languageIdentification();
        isInited = true;
    }

    private function OnLanguageClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLanguage);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            languageIdentification.identifyLanguage("My hovercraft is full of eels.",
                    function (language:String, error:LanguageIdentificationError):void {
                        languageIdentification.close();
                        if (error) {
                            statusLabel.text = "Natural Language error: " + error.errorID + " : " + error.message;
                            return;
                        }
                        statusLabel.text = "Language detected: " + language;
                    });
        }
    }

    private function OnPossibleLanguagesClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnPossibleLanguages);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            languageIdentification.identifyPossibleLanguages("an amicable coup d'etat",
                    function (languages:Vector.<IdentifiedLanguage>, error:LanguageIdentificationError):void {
                        languageIdentification.close();
                        if (error) {
                            statusLabel.text = "Natural Language error: " + error.errorID + " : " + error.message;
                            return;
                        }
                        statusLabel.text = "";
                        for each (var language:IdentifiedLanguage in languages) {
                            statusLabel.text = statusLabel.text + language.languageCode + " : "
                                    + Math.floor(language.confidence * 100) + "%\n";
                        }
                    });
        }
    }

}
}
