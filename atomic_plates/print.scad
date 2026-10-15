use <plates.scad>;
use <joint.scad>;


// total number of plates to print
numberOfPlates=1;

// height of frame
height = 15;
// number of modules along the X-axis
no_of_modules_x = 1;
// size of each module
modulesize = 50;
//render joints
renderJoints = true;

if(numberOfPlates > 0)
    printPlate(numberOfPlates, modulesize, height, no_of_modules_x);

if (renderJoints)
    printJoints(h=height, t=4);

module printPlate(pcount = 1, w=modulesize, h=10, no_of_modules_x = 3)
{
    t=4;

    th=h+t;

    plateoffset = no_of_modules_x * w +10;

    for(i = [0:pcount-1])
        translate([i*plateoffset, 0, th])
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

    
    angles = [0, 45, 90];

    //all angles moved by 180 degrees around the Z-axis
    for(i = [0:len(angles)-1])
    {
        rotate([0, 90, 0])
            translate([-joint_w/2, 80, i  * 40])
            rotate([0, 0, 90])
            angle_joint(angles[i], t, h);
    }

}


module joints_tuning(h=15, t=4)
{
    joint_h = joint_height();
    joint_w = joint_width();



    rotate([0, 90, 0])
        translate([-joint_w/2, 0, 0])
        rotate([0, 0, 90])
        angle_joint(0, t, h);
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
