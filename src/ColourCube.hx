
class ColourCube {
    private var used : BloomFilter;
    // HashSet<ColourProxy>;

    public function new() {
        // used = new HashSet<ColourProxy>(256 * 256 * 256);
        used = new BloomFilter(32, 50);
    }

    public function consume(colour : ColourProxy) : Void {
        this.used.add(colour.toString());
    }

    public function colourUsed(colour : ColourProxy) : Bool {
        return this.used.has(colour.toString());
    }

    public function nearest(colour : ColourProxy) : ColourProxy {
        return new ColourProxy(
            colour.r + 1,
            colour.g + 1,
            colour.b + 1
        );
    }

    public function toString() : String {
        return "{ ColourCube }";
    }
}
