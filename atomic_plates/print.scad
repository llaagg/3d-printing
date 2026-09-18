use <plates.scad>;
use <joint.scad>;


// translate([0, 0, 19])
//     rotate([0, 180, 0])
//     print_footprint(sizex = 100, sizey = 100);

// translate([0, 130   , 19])
//     rotate([0, 180, 0])
//     print_footprint();

//
module showTwoPlates(angle) {
    translate([-50, 50 - 12, 0])
        rotate([90, 0, 0])
            print_footprint();
}

// joints
translate([00, 0,0])
{
    translate([0, 0, 8.5])
        rotate([90, 0, 0])
            angle_joint();

    translate([0, 15, 8.5])
        rotate([90, 0, 0])
            angle_joint(30);
    //showTwoPlates(30);

    translate([0, 30, 8.5])
        rotate([90, 0, 0])
            angle_joint(45);

    translate([0, 45, 8.5])
        rotate([90, 0, 0])
            angle_joint(60);


    translate([0, 60, 8.5])
        rotate([90, 0, 0])
            angle_joint(90);



    // translate([0, 30, 8.5])
    //     rotate([90, 0, 0])
    //         angle_joint(45);


    // translate([0, 60, 8.5])
    //     rotate([90, 0, 0])
    //         angle_joint(60);


}