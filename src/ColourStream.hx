
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
        while (!position_q.isEmpty()) {
            // 2. Pop a point off of the queue
            var pos = position_q.dequeue();
            trace('colouring ' + pos + ' from ' + position_q);

            if (pos == START_POS) {
                // 3. If it’s the first point, colour it the starting colour and
                // note that colour has been consumed (then goto step 7)
                img.setPixel(pos, START_COLOUR);
                cube.consume(START_COLOUR);
            } else {
                // 4. If it’s not the first point, calculate it’s “target colour” by
                // averaging the colours of the 8 adjacent points (they only
                // contribute to the average if they themselves have been coloured)
                var target_colour = getEightAverage(img, pos);

                // 5. Using that target colour, search the space of unused colours
                // for the nearest match (this is done by treating the RGB space as
                // a voxel cube [see image below] which is searched in expanding
                // spheres about the target colour point)
                var nearest_color = cube.nearest(target_colour);

                // 6. Colour the popped point with the matched colour and note that
                // colour has been consumed
                img.setPixel(pos, nearest_color);
            }

            // 7. In either case, enqueue the uncoloured, unqueued points adjacent
            // to the point popped off the queue (this is done using a goroutine so
            // as not to suspend the main thread’s search for viable colours)

            // position_q.enqueue(
            //     // pos + new Position(0, 2)
            //     pos.add(new Position(0, 2))
            // );
            // Sys.sleep(5);
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
