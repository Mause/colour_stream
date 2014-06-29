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
}
