use <plates.scad>;
use <joint.scad>;

// Small XY inset for the top panel only.
top_trim = 0.1;

module print_footprint(top_trim = 0) {
    footprint_box(50, 50, 15,
        joints=[["east", 0, 0], ["north", 0, 0], ["south", 0, 0], ["west", 0, 0]],
        top_trim = top_trim);
}

translate([0, 0, 19])
    rotate([0, 180, 0])
    print_footprint(top_trim);

translate([0, 90, 19])
    rotate([0, 180, 0])
    print_footprint(top_trim);

// translate([0, 0, 8.5])
//     rotate([90, 0, 0])
//         angle_joint();

// translate([0, 30, 8.5])
//     rotate([90, 0, 0])
//         angle_joint(45);


// translate([0, 60, 8.5])
//     rotate([90, 0, 0])
//         angle_joint(60);

