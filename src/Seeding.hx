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

    public static function showSeeds(seed_colours : Array<Colour>) : Void {
        trace(seed_colours);

        var seed_display = new flash.display.BitmapData(
            seed_colours.length * 50, 50,
            false, 0 // 0x00CCCCCC
        );

        flash.Lib.current.stage.addChild(
            new flash.display.Bitmap(seed_display)
        );

        var y_offset = 0;
        for (col in seed_colours) {
            for (x in 0...50) {
                for (y in 0...50) {
                    seed_display.setPixel(
                        x, y_offset + y,
                        col.asHex()
                    );
                }

            }

            y_offset += 50;
        }
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
