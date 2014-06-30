class ColourProxy implements de.polygonal.ds.Hashable {
    public var r : Int;
    public var g : Int;
    public var b : Int;
    public var coloured : Bool = true;

    public var key : Int; // to make it Hashable

    public function new(r : Int, g : Int, b : Int, ?coloured=true) {
        function acceptable(i) return (0 <= i) && (i <= 256);

        if (!acceptable(r)) throw new BadColour("bad value for r; " + r);
        this.r = r;

        if (!acceptable(g)) throw new BadColour("bad value for g; " + g);
        this.g = g;

        if (!acceptable(b)) throw new BadColour("bad value for b; " + b);
        this.b = b;

        this.coloured = coloured;
    }

    public function toString() {
        return '{ ColourProxy ${r} ${g} ${b} ${asHex()} }';
    }

    public function asHex() {
        return (1 << 24) + (r << 16) + (g << 8) + b;
    }

    public function asHexString() : String {
        return "#" + StringTools.hex(asHex());
    }

    public static function fromHex(hex : String) {
        var re : EReg = ~/^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i;

        if (re.match(hex)) {
            return new ColourProxy(
                Std.parseInt("0x" + re.matched(1)),
                Std.parseInt("0x" + re.matched(2)),
                Std.parseInt("0x" + re.matched(3))
            );
        } else return null;
    }

    public function iterator() {
        return new ColourProxyIter(this);
    }

    public function equals(other : ColourProxy) {
        return (
            r == other.r &&
            g == other.g &&
            b == other.b
        );
    }

    public function add(other : ColourProxy) {
        return new ColourProxy(
            r + other.r,
            g + other.g,
            b + other.b
        );
    }

    public static function randomColour() {
        return new ColourProxy(Std.random(255), Std.random(255), Std.random(255));
    }
}

class ColourProxyIter {

    private var colour : ColourProxy;
    private var idx : Int;

    public function new(colour : ColourProxy) {
        this.colour = colour;
        this.idx = 0;
    }

    public function hasNext() {
        return idx < 3;
    }

    public function next() {
        idx++;
        switch(idx) {
            case 1: return this.colour.r;
            case 2: return this.colour.g;
            case 3: return this.colour.b;
            default: throw "invalid and impossible state";
        }
    }
}
