package roipeker.display {
import starling.core.Starling;
import starling.display.Mesh;
import starling.geom.Polygon;
import starling.rendering.IndexData;
import starling.rendering.VertexData;

public class MeshRoundRect extends Mesh {

    private var _vdata:VertexData;
    private var _idata:IndexData;
    private var _w:Number;
    private var _h:Number;

    private var _topLeftRadius:Number = 0;
    private var _topRightRadius:Number = 0;
    private var _bottomLeftRadius:Number = 0;
    private var _bottomRightRadius:Number = 0;

    private var _vertices:Array;

    private static const HALF_PI:Number = Math.PI / 2;
    // resolution
    private var _curveSteps:uint = 0;
    private var _poly:Polygon;
    private var _color:uint;
    private var _invalidateColor:Boolean = false;

    /**
     * Constructor.
     * @param curveSteps (leave it at 0 to be 1 step per radius pixel.
     */
    public function MeshRoundRect(curveSteps:uint = 0) {
        this._curveSteps = curveSteps;
        _vdata = new VertexData();
        _idata = new IndexData();
        _vertices = [];
        _poly = new Polygon();
        super(_vdata, _idata);
    }

    private function invalidate():void {
        if (!Starling.juggler.containsDelayedCalls(onInvalidate)) {
            Starling.juggler.delayCall(onInvalidate, 0);
        }
    }

    private function onInvalidate():void {

        // dont render anything.
        if (_w < 1 && _h < 1) {
            _vdata.clear();
            _idata.clear();
            setIndexDataChanged();
            return;
        }

        if (!_invalidateColor) {
            // redraw.
            _vertices.length = 0;

            const hh:Number = _h / 2 - 1;
            const hw:Number = _w / 2 - 1;
            // constrain radius.
            if (_topRightRadius >= hh) _topRightRadius = hh;
            if (_topRightRadius >= hw) _topRightRadius = hw;
            if (_topLeftRadius >= hh) _topLeftRadius = hh;
            if (_topLeftRadius >= hw) _topLeftRadius = hw;
            if (_bottomLeftRadius >= hh) _bottomLeftRadius = hh;
            if (_bottomLeftRadius >= hw) _bottomLeftRadius = hw;
            if (_bottomRightRadius >= hh) _bottomRightRadius = hh;
            if (_bottomRightRadius >= hw) _bottomRightRadius = hw;

            drawQuart(_topLeftRadius, _topLeftRadius, _topLeftRadius, -HALF_PI * 2, _curveSteps);
            drawQuart(_w - _topRightRadius, _topRightRadius, _topRightRadius, -HALF_PI, _curveSteps);
            drawQuart(_w - _bottomRightRadius, _h - _bottomRightRadius, _bottomRightRadius, 0, _curveSteps);
            drawQuart(_bottomLeftRadius, _h - _bottomLeftRadius, _bottomLeftRadius, HALF_PI, _curveSteps);

            _vdata.clear();
            _idata.clear();

            _poly.numVertices = 0;
            _poly.addVertices.apply(null, _vertices);
            _poly.triangulate(_idata);
            _poly.copyToVertexData(_vdata);
        }

        _vdata.colorize('color', _color);
        setIndexDataChanged();
        _invalidateColor = false;
    }

    private function drawQuart(x:Number, y:Number, r:Number, offset:Number, steps:uint = 0):void {
        if (r < 1) r = 1;
        if (steps == 0) {
            steps = r | 0;
            if (steps < 2) steps = 2;
        }
        var v:Array = _vertices;
        var pos:uint = v.length;
        var ad:Number = HALF_PI / (steps - 1);
        var a:Number = offset;
        for (var i:int = 0; i < steps; i++) {
            v[int(pos + i * 2)] = x + Math.cos(a) * r;
            v[int(pos + i * 2 + 1)] = y + Math.sin(a) * r;
            a += ad;
        }
    }

    /**
     * Utility to draw at once.
     * @param w
     * @param h
     * @param allOrTopLeftRadius
     * @param topRightRadius
     * @param bottomRightRadius
     * @param bottomLeftRadius
     */
    public function setup(w:Number, h:Number, allOrTopLeftRadius:Number, topRightRadius:Number = -1, bottomRightRadius:Number = -1, bottomLeftRadius:Number = -1):void {
        this.w = w;
        this.h = h;
        if (topRightRadius < 0 && topRightRadius < 0 && bottomRightRadius < 0 && bottomLeftRadius < 0) {
            this.radius = allOrTopLeftRadius;
        } else {
            this.topLeftRadius = allOrTopLeftRadius;
            this.topRightRadius = topRightRadius;
            this.bottomRightRadius = bottomRightRadius;
            this.bottomLeftRadius = bottomLeftRadius;
        }
    }

    public function setSize(w:Number, h:Number):void {
        this.w = w;
        this.h = h;
    }

    public function move(x:Number, y:Number):void {
        this.x = x;
        this.y = y;
    }

    public function get w():Number {
        return _w;
    }

    public function set w(value:Number):void {
        if (_w == value) return;
        _w = value;
        invalidate();
    }

    public function get h():Number {
        return _h;
    }

    public function set h(value:Number):void {
        if (_h == value) return;
        _h = value;
        invalidate();
    }

    public function get radius():Number {
        return _topLeftRadius;
    }

    public function set radius(value:Number):void {
        if (_topLeftRadius == value &&
                _topRightRadius == value &&
                _bottomLeftRadius == value &&
                _bottomRightRadius == value) return;
        _topLeftRadius = _topRightRadius = _bottomLeftRadius = _bottomRightRadius = value;
        invalidate();
    }

    override public function get color():uint {
        return _color;
    }

    override public function set color(value:uint):void {
        if (_color == value) return;
        _color = value;

        _vdata.colorize("color", _color);
        setIndexDataChanged();
    }

    public function get topLeftRadius():Number {
        return _topLeftRadius;
    }

    public function set topLeftRadius(value:Number):void {
        if (_topLeftRadius == value) return;
        if (value < 0) value = 0;
        _topLeftRadius = value;
        invalidate();
    }

    public function get topRightRadius():Number {
        return _topRightRadius;
    }

    public function set topRightRadius(value:Number):void {
        if (_topRightRadius == value) return;
        if (value < 0) value = 0;
        _topRightRadius = value;
        invalidate();
    }

    public function get bottomLeftRadius():Number {
        return _bottomLeftRadius;
    }

    public function set bottomLeftRadius(value:Number):void {
        if (_bottomLeftRadius == value) return;
        if (value < 0) value = 0;
        _bottomLeftRadius = value;
        invalidate();
    }

    public function get bottomRightRadius():Number {
        return _bottomRightRadius;
    }

    public function set bottomRightRadius(value:Number):void {
        if (_bottomRightRadius == value) return;
        if (value < 0) value = 0;
        _bottomRightRadius = value;
        invalidate();
    }

    public function get curveSteps():uint {
        return _curveSteps;
    }

    /**
     * How many vertices to draw each corner (like curve resolution).
     * Use 0 to use 100% accurate (remember to
     * @param value     default to 0 to cal
     */
    public function set curveSteps(value:uint):void {
        if (_curveSteps == value) return;
        _curveSteps = value;
        invalidate();
    }

}
}
