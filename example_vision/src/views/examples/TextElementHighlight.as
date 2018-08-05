package views.examples {
import flash.geom.Rectangle;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;

public class TextElementHighlight extends Sprite {
    private var lbl:TextField;
    public function TextElementHighlight(frame:Rectangle, text:String) {
        var LINE_WIDTH:Number = 2;
        var fill:Quad = new Quad(frame.width - (LINE_WIDTH * 2), frame.height - (LINE_WIDTH * 2), 0xFFFF00);
        var left:Quad = new Quad(LINE_WIDTH, frame.height - (LINE_WIDTH * 2), 0xFFFF00);
        var right:Quad = new Quad(LINE_WIDTH, frame.height - (LINE_WIDTH * 2), 0xFFFF00);
        var top:Quad = new Quad(frame.width, LINE_WIDTH, 0xFFFF00);
        var bot:Quad = new Quad(frame.width, LINE_WIDTH, 0xFFFF00);
        fill.x = fill.y = LINE_WIDTH;
        fill.alpha = 0.25;
        left.alpha = right.alpha = top.alpha = bot.alpha = 0.75;
        bot.y = frame.height - (LINE_WIDTH * 2);
        right.y = left.y = LINE_WIDTH;
        right.x = frame.width - (LINE_WIDTH);

        addChild(fill);
        addChild(top);
        addChild(right);
        addChild(bot);
        addChild(left);

        lbl = new TextField(frame.width + 5, frame.height + 5, text);
        lbl.format.setTo(Fonts.NAME, 13, 0x222222, Align.CENTER, Align.TOP);
        lbl.touchable = false;
        lbl.x = 2;
        lbl.y = LINE_WIDTH;
        addChild(lbl);

        this.x = frame.x;
        this.y = frame.y;

    }
}
}
