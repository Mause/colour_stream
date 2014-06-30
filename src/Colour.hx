class BadColour extends haxe.more.exceptions.Exception {}

class Colour {
    public var r : Int;
    public var g : Int;
    public var b : Int;
    public var coloured : Bool = true;

    public function new(r : Int, g : Int, b : Int, ?coloured=true) {
        assertAcceptable(r, "r"); this.r = r;
        assertAcceptable(g, "g"); this.g = g;
        assertAcceptable(b, "b"); this.b = b;

        this.coloured = coloured;

    }

    private function assertAcceptable(val, name) {
        if (!((0 <= val) && (val <= 256))) {
            throw new BadColour("bad value for " + name + "; " + val);
        }
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
            return new Colour(
                Std.parseInt("0x" + re.matched(1)),
                Std.parseInt("0x" + re.matched(2)),
                Std.parseInt("0x" + re.matched(3))
            );
        } else return null;
    }

    public function iterator() {
        return new ColourIter(this);
    }

    public function equals(other : Colour) {
        return (
            r == other.r &&
            g == other.g &&
            b == other.b
        );
    }

    public function add(other : Colour) {
        return new Colour(
            r + other.r,
            g + other.g,
            b + other.b
        );
    }

    public static function randomColour() {
        return new Colour(Std.random(255), Std.random(255), Std.random(255));
    }
}

class ColourIter {

    private var colour : Colour;
    private var idx : Int;

    public function new(colour : Colour) {
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
