class PositionGeneration {
    public static var EIGHT_DIFFERENCES : Array<Position>;
    public static var FOUR_DIFFERENCES : Array<Position>;

    public static function generateStaticPositions() {
        EIGHT_DIFFERENCES = [
            for (x in [-2, -1, 0, 1, 2])
            for (y in [-2, -1, 0, 1, 2])
            new Position.RelativePosition(x, y)
        ];

        // should the current position not be considered?
        EIGHT_DIFFERENCES.remove(new Position.Position(0, 0));

        FOUR_DIFFERENCES = [
            new Position.RelativePosition(0, -1),    // up
            new Position.RelativePosition(0, 1),     // down
            new Position.RelativePosition(-1, 0),    // left
            new Position.RelativePosition(1, 0)      // right
        ];
    }

    static function arrayAvg(array : Array<Int>) : Int {
        var total = 0;
        for (num in array) {
            total += num;
        }
        return Math.round(total / array.length);
    }

    public static function getUncolouredAdjacent(img, pos : Position) {
        var uncoloured = [];
        var pos_val;

        for (diff_pos in PositionGeneration.FOUR_DIFFERENCES) {
            diff_pos = pos.add(diff_pos);

            try {
                pos_val = img.getPixel(diff_pos);
            } catch (e : Image.InvalidCoordinate) {
                // invalid coordinate
                continue;
            }

            if (!pos_val.coloured) {
                uncoloured.push(diff_pos);
            }
        }
        return uncoloured;
    }

    public static function getEightAverage(img, pos) : Colour {
        // 4. If it’s not the first point, calculate it’s “target colour” by
        // averaging the colours of the 8 adjacent points (they only
        // contribute to the average if they themselves have been coloured)

        var reds   = new Array<Int>();
        var greens = new Array<Int>();
        var blues  = new Array<Int>();

        for (diff_pos in PositionGeneration.EIGHT_DIFFERENCES) {
            var pix;
            try {
                pix = img.getPixel(pos.add(diff_pos));
            } catch (e : Image.InvalidCoordinate) continue;

            if (pix != null) {
                if ((pix.r + pix.g + pix.b) != 0) {
                    reds.insert(0, pix.r);
                    greens.insert(0, pix.g);
                    blues.insert(0, pix.b);
                }
            }
        }

        return new Colour(
            arrayAvg(reds),
            arrayAvg(blues),
            arrayAvg(greens)
        );
    }
}
