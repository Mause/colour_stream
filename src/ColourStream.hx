import de.polygonal.Printf;

class PositionGeneration {
    public static var EIGHT_DIFFERENCES : Array<Position>;

    public static function generateStaticPositions() {
        EIGHT_DIFFERENCES = [
            for (x in [-2, -1, 0, 1, 2])
            for (y in [-2, -1, 0, 1, 2])
            new Position.RelativePosition(x, y)
        ];
    }
}


class ColourStream {
    static var START_POS : Position = new Position(0, 0);
    static var START_COLOUR : ColourProxy = new ColourProxy(0, 0, 0);

    static var WIDTH = 512;
    static var HEIGHT = 512;

    static function arrayAvg(array : Array<Int>) {
        var total = 0;
        for (num in array) {
            total += num;
        }
        return Math.round(total / array.length);
    }

    static function getUncolouredAdjacent(img, pos : Position) {
        var uncoloured = [];

        for (diff_pos in PositionGeneration.FOUR_DIFFERENCES) {
            diff_pos = pos.add(diff_pos);

            var pos_val = img.getPixel(diff_pos);
            if (pos_val == null) continue; // avoid null reference

            if (!pos_val.coloured) {
                uncoloured.push(diff_pos);
            }
        }
        return uncoloured;
    }

    static function getEightAverage(img, pos) : ColourProxy {
        var reds = new Array<Int>();
        var greens = new Array<Int>();
        var blues = new Array<Int>();

        for (diff_pos in PositionGeneration.EIGHT_DIFFERENCES) {
            var pix;
            try {
                pix = img.getPixel(pos.add(diff_pos));
            } catch (e : Dynamic) continue;

            if (pix != null) {
                if ((pix.r + pix.g + pix.b) != 0) {
                    reds.insert(0, pix.r);
                    greens.insert(0, pix.g);
                    blues.insert(0, pix.b);
                }
            }
        }

        return new ColourProxy(
            arrayAvg(reds),
            arrayAvg(blues),
            arrayAvg(greens)
        );
    }

    static function injectFlashTrace() {
        #if (flash9 || flash10)
            haxe.Log.trace = function(v,?pos) {
                untyped __global__["trace"](
                    pos.className+"#"+pos.methodName+"("+pos.lineNumber+"):",
                    v
                );
            }
        #elseif flash
            haxe.Log.trace = function(v,?pos) {
                flash.Lib.trace(
                    pos.className+"#"+pos.methodName+"("+pos.lineNumber+"): "+v
                );
            }
        #end
    }

    static function main() {
        PositionGeneration.generateStaticPositions();

        var position_q = new de.polygonal.ds.LinkedQueue<Position>(500);
        var cube = new ColourCube();
        var img = new Image(WIDTH, HEIGHT);

        // 1. Enqueue the initial point (that is, some x, y point on the image)
        position_q.enqueue(START_POS);

        trace("Entering main loop");
        var seen_positions = 0;  // TODO: remove this
        while (!position_q.isEmpty()) {
            // 2. Pop a point off of the queue
            var pos = position_q.dequeue();
            if (img.getPixel(pos).coloured) continue; // already coloured, don't recolour

            seen_positions++;
            var percentage_done = seen_positions / (WIDTH * HEIGHT) * 100;
            var spd = Printf.format('%.2f%%\r', [percentage_done]);

            #if (neko || cpp)
            Sys.print(spd);
            #else
            trace(spd);
            #end

            if (pos.equals(START_POS)) {
                // 3. If it’s the first point, colour it the starting colour and
                // note that colour has been consumed (then goto step 7)
                img.setPixel(pos, START_COLOUR);
                cube.consume(START_COLOUR);
            } else {
                // 4. If it’s not the first point, calculate it’s “target colour” by
                // averaging the colours of the 8 adjacent points (they only
                // contribute to the average if they themselves have been coloured)
                var target_colour = PositionGeneration.getEightAverage(img, pos);

                // 5. Using that target colour, search the space of unused colours
                // for the nearest match (this is done by treating the RGB space as
                // a voxel cube [see image below] which is searched in expanding
                // spheres about the target colour point)
                var nearest_color = cube.nearest(target_colour);

                // 6. Colour the popped point with the matched colour and note that
                // colour has been consumed
                img.setPixel(pos, nearest_color);
                cube.consume(nearest_color);
            }

            // 7. In either case, enqueue the uncoloured, unqueued points adjacent
            // to the point popped off the queue (this is done using a goroutine so
            // as not to suspend the main thread’s search for viable colours)

            for (adj in PositionGeneration.getUncolouredAdjacent(img, pos)) {
                position_q.enqueue(adj);
            }
        }

        var mid = Math.round(img.width / 2);
        img.setPixel(
            new Position(mid, mid),
            new ColourProxy(128, 128, 128)
        );

        img.writeOut("filename.png");
        img.display();
    }

    public function toString() {
        return '{ ColourStream }';
    }
}
