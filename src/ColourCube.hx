import de.polygonal.ds.HashSet;


interface ColourUsedDeterminer {
    function colourUsed(col : Colour) : Bool;
    function consume(col : Colour) : Void;
}

class BloomFilterCUD implements ColourUsedDeterminer {
    private var used : BloomFilter;
    public function new() used = new BloomFilter(32, 50);
    public function consume(col : Colour) this.used.add(col.toString());
    public function colourUsed(col : Colour) return this.used.has(col.toString());
}

class HashSetCUD implements ColourUsedDeterminer {
    private var used : HashSet<Colour>;
    public function new() used = new HashSet<Colour>(256); // * 256 * 256);
    public function consume(col : Colour) this.used.set(col);
    public function colourUsed(col : Colour) return this.used.has(col);
}


class BitCUD implements ColourUsedDeterminer {
    private var used : de.polygonal.ds.BitVector;
    public function new() {
        used = new de.polygonal.ds.BitVector(
            Math.floor(Math.pow(256, 3))
        );
    }

    public function consume   (col : Colour) used.set(col.asHex());
    public function colourUsed(col : Colour) return used.has(col.asHex());

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

    public function consume(col : Colour) {
        this.used.consume(col);
        Assert.assert(this.used.colourUsed(col));
    }

    public function surroundingSphere(innerRadius : Int, outerRadius : Int) : Array<Colour> {
        var colours = [];

        for (point in Sphere.sphere_points(outerRadius, outerRadius, innerRadius)) {
            try {
                colours.push(
                    new Colour(point[0], point[1], point[2])
                );
            } catch (e : Colour.BadColour) {};
        }

        return colours;
    }

    public function closeEnough(distance, first : Colour, second : Colour) : Bool {
        var r_diff = Math.abs(first.r - second.r),
            g_diff = Math.abs(first.g - second.g),
            b_diff = Math.abs(first.b - second.b),
            diff = r_diff + g_diff + b_diff;

        return (0 <= diff) && (diff <= TOLERANCE);
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
