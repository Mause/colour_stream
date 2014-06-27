class ColourProxy implements de.polygonal.ds.Hashable {
    public var r : Int;
    public var g : Int;
    public var b : Int;
    public var coloured : Bool;

    public var key : Int; // to make it Hashable

    public function new(r : Int, g : Int, b : Int, ?coloured=true) {
        this.r = r >= 0 ? r : 0;
        this.g = g >= 0 ? g : 0;
        this.b = b >= 0 ? b : 0;
        this.coloured = coloured;
    }

    public function toString() {
        return '{ ColourProxy ${r} ${g} ${b} ${asHex()} }';
    }

    public function asHex() {
        return (1 << 24) + (r << 16) + (g << 8) + b;
    }

    public function asHexString() : String {
        return "#" + asHex();
    }

    public function fromHex(hex : String) {
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
