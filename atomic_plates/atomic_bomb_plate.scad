top_thickness = 4;
top_t = top_thickness;

include <plates.scad>;

// Select "preview" to see the two-color plate, or export "plate" and
// "inlay" separately to assign them different filament colors in a slicer.
part = "preview";

plate_width = 50;
plate_length = 50;
wall_height = 10;

inlay_depth = 0.6;
line_width = 0.8;
plate_color = [0.82, 0.82, 0.78];
inlay_color = [0.9, 0.18, 0.08];

// One closed, continuous mushroom-cloud outline, centered on the plate.
bomb_outline = [
    [0, 13], [-3, 12], [-5, 10], [-6, 7], [-9, 7],
    [-11, 8], [-14, 8], [-16, 6], [-15.5, 4], [-13, 3],
    [-10, 3], [-9, 1], [-7, -1], [-6, -3], [-6, -8],
    [-9, -9], [-11, -10], [-10, -11], [-6, -10], [-3, -11],
    [0, -10], [3, -11], [6, -10], [10, -11], [11, -10],
    [9, -9], [6, -8], [6, -3], [7, -1], [9, 1],
    [10, 3], [13, 3], [15.5, 4], [16, 6], [14, 8],
    [11, 8], [9, 7], [6, 7], [5, 10], [3, 12], [0, 13]
];

icon_scale = min(plate_width, plate_length) / 50;
surface_z = wall_height + top_thickness;

module bomb_line_2d() {
    translate([plate_width / 2, plate_length / 2])
        scale([icon_scale, icon_scale])
            for (i = [0 : len(bomb_outline) - 2])
                hull() {
                    translate(bomb_outline[i])
                        circle(d = line_width, $fn = 16);
                    translate(bomb_outline[i + 1])
                        circle(d = line_width, $fn = 16);
                }
}

module line_cavity() {
    translate([0, 0, surface_z - inlay_depth])
        linear_extrude(height = inlay_depth + 0.01)
            bomb_line_2d();
}

module plate_with_cavity() {
    difference() {
        footprint_box(
            plate_width,
            plate_length,
            wall_height,
            top_height = top_thickness
        );
        line_cavity();
    }
}

module bomb_line_inlay() {
    translate([0, 0, surface_z - inlay_depth])
        linear_extrude(height = inlay_depth)
            bomb_line_2d();
}

if (part == "plate") {
    plate_with_cavity();
} else if (part == "inlay") {
    bomb_line_inlay();
} else if (part == "preview") {
    color(plate_color) plate_with_cavity();
    color(inlay_color) bomb_line_inlay();
} else {
    assert(false, "part must be \"preview\", \"plate\", or \"inlay\"");
}
