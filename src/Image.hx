
class InvalidCoordinate extends haxe.more.exceptions.Exception {
    var coord : Position;

    public function new(coord) {
        super("Invalid coordinate; " + coord.toString());
    }
}


class Image {
    private var img : Array<Array<ColourProxy>>;
    public var width : Int;
    public var height : Int;

    public function new(width : Int, height : Int) {
        var column, row;

        this.img = [
            for (column in 0...width)
            [
                for (row in 0...height)
                new ColourProxy(0, 0, 0, false)
            ]
        ];

        this.width = height;
        this.height = width;
    }

    public function toString() {
        return '{ Image width: ${width} height: ${height} }';
    }

    public function setPixel(coord : Position, val : ColourProxy) {
        validateCoord(coord);
        this.img[coord.x][coord.y] = val;
    }

    public function validateCoord(coord : Position) {
        var x_ok = (0 <= coord.x) && (coord.x < width),
            y_ok = (0 <= coord.y) && (coord.y < height);
        if (!(x_ok && y_ok)) throw new Image.InvalidCoordinate(coord);
    }

    public function getPixel(coord : Position) {
        validateCoord(coord);
        return this.img[coord.x][coord.y];
    }

    public function display() {
        var to_display = new flash.display.BitmapData(
            this.width, this.height,
            false, 0x00CCCCCC
        );

        for (x in 0...this.width) {
            for (y in 0...this.height) {

                to_display.setPixel(
                    x, y,
                    this.img[x][y].asHex()
                );
            }
        }

        flash.Lib.current.stage.addChild(
            new flash.display.Bitmap(to_display)
        );
    }

    #if (js || flash || flash8)
    // does nothing on platforms with no filesystem access
    public function writeOut(filename : String) {}

    #else
    public function writeOut(filename : String) {
        var bo = new haxe.io.BytesOutput();
        for (column in this.img) {
            for (pixel in column) {
                for (channel in [pixel.b, pixel.g, pixel.r]) {
                    bo.writeByte(channel);
                }
            }
        }
        var bytes = bo.getBytes();
        writePixels24(filename, bytes, this.width, this.height);
    }

    private function writePixels24(file : String, pixels : haxe.io.Bytes, width : Int, height : Int) {
        var handle = sys.io.File.write(file, true);
        var writer = new format.png.Writer(handle);

        writer.write(format.png.Tools.buildRGB(width, height, pixels));

        handle.close();
    }
    #end
}
