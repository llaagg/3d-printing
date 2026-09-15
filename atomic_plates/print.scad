use <plates.scad>;
use <joint.scad>;

// Small crown trim for the top panel only.
top_trim = 0.5;

module print_footprint(tt = top_trim) {
    footprint_box(50, 50, 15,
        joints=[["east", 0, 0], ["north", 0, 0], ["south", 0, 0], ["west", 0, 0]],
        top_trim = tt);
}

translate([0, 0, 19])
    rotate([0, 180, 0])
    print_footprint(top_trim);

translate([0, 55, 19])
    rotate([0, 180, 0])
    print_footprint(0.3);

// joints
translate([20, 0,0])
{
    translate([0, 0, 8.5])
        rotate([90, 0, 0])
            angle_joint();

    translate([0, 0, 8.5])
        rotate([90, 0, 0])
            angle_joint();

    translate([0, 0, 8.5])
        rotate([90, 0, 0])
            angle_joint();

    translate([0, 30, 8.5])
        rotate([90, 0, 0])
            angle_joint(45);


    translate([0, 60, 8.5])
        rotate([90, 0, 0])
            angle_joint(60);


}