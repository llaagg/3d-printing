use <plates.scad>;
use <joint.scad>;


// total number of plates to print
numberOfPlates=1;

// height of frame
height = 10;
// number of modules along the X-axis
no_of_modules_x = 1;
// size of each module
modulesize = 50;

printPlate(numberOfPlates, modulesize, height, no_of_modules_x);
printJoints(h=height, t=4);

module printPlate(pcount = 1, w=modulesize, h=10, no_of_modules_x = 2)
{
    t=4;

    th=h+t;


    for(i = [0:pcount-1])
        translate([i*w + i*5, 0, th])
            rotate([0, 180, 0])
            print_footprint(
              sizex = w, sizey = w, sizez = h, 
              top = t, 
              scount_x = no_of_modules_x, scount_y = no_of_modules_x);
}

module printJoints(h=10, t=4)
{
    joint_h = joint_height();
    joint_w = joint_width();

    angles = [0, 45, 90, 180];
    
    //all angles moved by 180 degrees around the Z-axis
    for(i = [0:len(angles)-1])
    {
        rotate([0, 90, 0])
            translate([-joint_w/2, 80, (i + 2) * 20])
            rotate([0, 0, 90])
            angle_joint(angles[i], t, h);
    }

}


module demo90(a=90)
{
    h=10;
    t=5;

    th=h+t;

    joint_h = joint_height();

    rotate([0, 0, 180])
        angle_joint(a, t, h);

    translate([0, 0, -th])
        print_footprint(sizex = modulesize, sizey = modulesize, sizez = h, top = t, scount_x = no_of_modules_x, scount_y = no_of_modules_x);
    
    rotate([0, a, 0])
        translate([-50, 0, -th])
        print_footprint(sizex = modulesize, sizey = modulesize, sizez = h, top = t, scount_x = no_of_modules_x, scount_y = no_of_modules_x);
}
