class Position {
    public var x : Int;
    public var y : Int;

    public function new(x : Int, y : Int) {
        this.x = x;
        this.y = y;
    }

    public function add(other : Position) {
        return new Position(
            this.x + other.x,
            this.y + other.y
        );
    }

    public function toString() {
        return '{ Position x: ${x} y: ${y} }';
    }

    public function equals(other) {
        return (x == other.x && y == other.y);
    }
}

class RelativePosition extends Position {
    // difference is purely semantic
    public override function toString() {
        return '{ RelativePosition ' + super.toString().substr(11);
    }
}

// @:forward
// abstract Addable(Position) from Position to Position {
//     @:op( A + B ) static public function add(lhs : Addable, rhs : Position) {
//         return lhs.add(rhs);
//     }
// }
