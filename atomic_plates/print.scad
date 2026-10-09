use <plates.scad>;
use <joint.scad>;


// translate([0, 0, 19])
//     rotate([0, 180, 0])
//     print_footprint(sizex = 100, sizey = 100);

translate([60, 60, 0])
    showTwoPlates(90);

module showTwoPlates(angle) {
     translate([0, 0   , 0])
        rotate([0, 0, 0])
        print_footprint();

    translate([50, 0   , 0])
        rotate([0, angle, 0])
        print_footprint();

    translate([50, 25   , 1])
        angle_joint(angle);

    translate([ -20, 0 , 70])
        rotate([0, angle, 0])
        print_footprint();

    translate([  0, 25   , 14])
        rotate([0, angle+90, 0])
        angle_joint(angle);

}


// joints
translate([30, 0,0])
{
    translate([0, 0, 8.5])
        rotate([90, 0, 0])
            angle_joint();

    translate([0, 15, 8.5])
        rotate([90, 0, 0])
            angle_joint(30);

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