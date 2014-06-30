import de.polygonal.ds.HashSet;


interface ColourUsedDeterminer {
    function colourUsed(col : ColourProxy) : Bool;
    function consume(col : ColourProxy) : Void;
}

class BloomFilterCUD implements ColourUsedDeterminer {
    private var used : BloomFilter;
    public function new() used = new BloomFilter(32, 50);
    public function consume(col : ColourProxy) this.used.add(col.toString());
    public function colourUsed(col : ColourProxy) return this.used.has(col.toString());
}

class HashSetCUD implements ColourUsedDeterminer {
    private var used : HashSet<ColourProxy>;
    public function new() used = new HashSet<ColourProxy>(256 * 256 * 256);
    public function consume(col : ColourProxy) this.used.set(col);
    public function colourUsed(col : ColourProxy) return this.used.has(col);
}


class BitCUD implements ColourUsedDeterminer {
    private var used : de.polygonal.ds.BitVector;
    public function new() {
        used = new de.polygonal.ds.BitVector(
            Math.floor(Math.pow(256, 3))
        );
    }

    public function consume   (col : ColourProxy) used.set(col.asHex());
    public function colourUsed(col : ColourProxy) return used.has(col.asHex());

    public function toString() : String {
        var kbsize = (used.capacity() / 8) / 1024;
        return '{ BitCUD size: $kbsize kilobytes }';
    }
}


class ColourCube {
    public var used : ColourUsedDeterminer;

    public function new() {
        used = new BitCUD();  // probably the most accurate and memory efficent
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
