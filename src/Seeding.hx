class Seeding {
    public static function seed(img : Image) : Array<Position> {
        var seeds = [];

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
