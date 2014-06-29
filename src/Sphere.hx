using Lambda;

class Sphere {
    public static function within_radius(centre_point, outer_radius, ?inner_radius=0.0) {
        function inner(current_point) {
            var rel_x = centre_point[0] - current_point[0];
            var rel_y = centre_point[1] - current_point[1];
            var rel_z = centre_point[2] - current_point[2];

            var distance = Math.sqrt(
                Math.pow(rel_x, 2) +
                Math.pow(rel_y, 2) +
                Math.pow(rel_z, 2)
            );

            return (outer_radius >= distance) && (distance >= inner_radius);
        }

        return inner;
    }

    public static function square_points(radius, ?outer_radius, ?inner_radius) {
        if (outer_radius == null) outer_radius = radius;
        if (inner_radius == null) inner_radius = radius - .5;

        var range = [];
        for (i in -(radius - 1)...0) { range.push(i); } // below zero
        for (i in        0...radius) { range.push(i); } // above zero

        return [
            for (x in range)
            for (y in range)
            for (z in range)
            [x, y, z]
        ];
    }

    public static function sphere_points(radius, ?outer_radius, ?inner_radius) {
        if (outer_radius == null) outer_radius = radius;
        if (inner_radius == null) inner_radius = radius - .5;

        var points = square_points(radius, outer_radius, inner_radius);

        return points.filter(
            within_radius([0, 0, 0], outer_radius, inner_radius)
        );
    }

    // function points(R : Int, D : Int) : Array<Array<Int>> {
    //     var all_points = [];

    //     for (part in partitions(R, D)) {             // e.g. 4->[3,1]
    //         // e.g. [3,1]->[3,1,0] (padding)
    //         // trace('part in partitions', part);

    //         var num_padding = Math.floor(D - part.length);
    //         for (arb in 0...num_padding) {
    //             part.push(0);
    //         }

    //         // e.g. [1,3,0], [1,0,3], ...
    //         var perms : Array<Array<Int>> = permutations(part);
    //         var unique_perms : Array<Array<Int>> = [];

    //         for (perm in perms) {
    //             if (!(unique_perms.indexOf(perm) >= 0)) {
    //                 unique_perms.push(perm);
    //             }
    //         }

    //         for (perm in perms) {
    //             // e.g. [1,3,0], [-1,3,0], [1,-3,0], [-...
    //             // trace('perm in perms', perm);

    //             var filtered_points = [];
    //             for (x in perm) {
    //                 // trace('x in perm', x);
    //                 filtered_points.push(x != 0 ? [-x, x] : [0]);
    //             }

    //             var new_points = product(filtered_points);
    //             all_points = all_points.concat(new_points);
    //         }
    //     }

    //     return all_points;
    // }
}
