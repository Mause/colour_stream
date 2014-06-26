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

}

// @:forward
// abstract Addable(Position) from Position to Position {
//     @:op( A + B ) static public function add(lhs : Addable, rhs : Position) {
//         return lhs.add(rhs);
//     }
// }
