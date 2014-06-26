import de.polygonal.ds.HashSet;

class ColourCube {
    private var used : BloomFilter;
    // HashSet<ColourProxy>;
    // private var field : Array<Array<Array<ColourProxy>>>;
    // private var field : Array<Array<Array<Array<Int>>>>;

    public function new() {
        // should probably just use math instead of an in memory cube :P
        // this.field = [
        //     for (b in 0...256)
        //     [
        //         for (g in 0...256)
        //         [
        //             for (r in 0...256)
        //             [
        //                 for (band in 0...3)
        //                 0
        //             ]
                    // new ColourProxy(r, g, b)
        //         ]
        //     ]
        // ];
        trace("building used set");
        // used = new HashSet<ColourProxy>(256 * 256 * 256);
        used = new BloomFilter(32, 50);
        trace("set built");
    }

    public function consume(colour : ColourProxy) {
        // this.used.set(colour);
        this.used.add(colour.toString());
    }

    public function nearest(colour : ColourProxy) {
        return new ColourProxy(
            colour.r + 1,
            colour.g + 1,
            colour.b + 1
        );
    }

    public function toString() {
        return "{ ColourCube }";
    }
}
