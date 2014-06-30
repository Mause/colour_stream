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

class BitCUD implements ColourUsedDeterminer {
    private var used : de.polygonal.ds.BitVector;
    public function new() {
        used = new de.polygonal.ds.BitVector(
            new Colour(255, 255, 255).asHex()
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
    inline static var TOLERANCE = 2;

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

    public function nearest(colour : Colour) : Colour {
        // 5. Using that target colour, search the space of unused colours
        // for the nearest match (this is done by treating the RGB space as
        // a voxel cube [see image below] which is searched in expanding
        // spheres about the target colour point)
        Assert.assert((colour.r + colour.g + colour.b) != 0);

        // var innerRadius = 0;
        var outerRadius = 1;

        var spent_looking = 0; // TODO: remove
        while (true) { // look until we find something

            // in ever expanding spheres, look for something like the given colour
            for (rel_colour in surroundingSphere(outerRadius - 1, outerRadius)) {
                // if ((rel_colour.r + rel_colour.g + rel_colour.b) == 0) {
                //     trace('bad! ' + rel_colour);
                //     continue; // don't bother looking at the origin
                // }
                // trace('rel_colour: ' + rel_colour);

                var found_colour;

                // only if the colour is valid in rgb
                try {
                    found_colour = colour.add(rel_colour);
                } catch (e : Colour.BadColour) continue;

                // if (used.colourUsed(found_colour)) {
                    // trace(found_colour + ' used previously, whilest searching for colour for ' + colour);
                    // Sys.sleep(1);
                //     continue;
                // }

                // if (found_colour.equals(colour)) return found_colour;
                if (closeEnough(outerRadius, found_colour, colour)) return found_colour;
            }

            // innerRadius = outerRadius;
            // outerRadius = Math.ceil(outerRadius * 2);
            outerRadius = Math.floor(Math.pow(outerRadius, 2));

            // TODO: remove
            // Assert.assert(!(spent_looking > 50));
            spent_looking++;
        }
    }

    public function toString() : String {
        return "{ ColourCube }";
    }
}
