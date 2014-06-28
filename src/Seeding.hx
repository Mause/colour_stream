class Seeding {
    public static function seed(img : Image) : Array<Position> {
        var seeds = [];

        // var colour = new ColourProxy(Std.random(255), Std.random(255), Std.random(255));
        // trace('seed; ' + colour);

        // var box_size = 50;
        // for (x in 1...box_size) {
        //     for (y in 1...box_size) {
        //         img.setPixel(new Position(x, y), colour);
        //     }
        // }


        // var choices = [
        //     new ColourProxy(255, 0, 0),
        //     new ColourProxy(0, 255, 0),
        //     new ColourProxy(0, 0, 255)
        // ];

        for (position in 1...50) {
            var pos = new Position(position, position);
            img.setPixel(pos,
                ColourProxy.randomColour()
                // Random.fromArray(choices)
            );
            seeds.push(pos);
        }
        return seeds;
    }

    // static function smudge_out_seeds(img : Image, seeds : Array<Position> ) : Image {
    //     var rseeds = [];
    //     for (seed in seeds) { rseeds.insert(0, seed); }

    //     for (pos in rseeds) {
    //         var beside = img.getPixel(pos.add(new Position.RelativePosition(1, 0)));
    //         img.setPixel(
    //             pos,
    //             // getEightAverage(img, pos)
    //             beside
    //         );
    //     }
    //     return img;
    // }
}
