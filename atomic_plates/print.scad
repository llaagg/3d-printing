use <plates.scad>;
use <joint.scad>;


print(2);

module print(pcount = 1, w=50)
{
    h=10;
    t=5;

    th=h+t;

    joint_h = joint_height();
    joint_w = joint_width();

    angles = [0, 15, 45, 60, 90];
    
    //all angles moved by 180 degrees around the Z-axis
    for(i = [0:len(angles)-1])
    {
        rotate([0, 90, 0])
            translate([-joint_w/2, 80, (i + 2) * 20])
            rotate([0, 0, 90])
            angle_joint(angles[i], t, h);
    }

    for(i = [0:pcount-1])
        translate([i*w + i*5, 0, th])
            rotate([0, 180, 0])
            print_footprint(sizex = w, sizey = w, sizez = h, top = t);
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
        print_footprint(sizez = h, top = t);
    
    rotate([0, a, 0])
        translate([-50, 0, -th])
        print_footprint(sizez = h, top = t);
}

module printLarge() {
  translate([0, 0, 19])
    rotate([0, 180, 0])
      print_footprint(sizex=100, sizey=100);
}

module showTwoPlates(angle) {
  translate([0, 0, 0])
    rotate([0, 0, 0])
      print_footprint();

  translate([50, 0, 0])
    rotate([0, angle, 0])
      print_footprint();

  translate([50, 25, 1])
    angle_joint(angle);

  translate([-20, 0, 70])
    rotate([0, angle, 0])
      print_footprint();

  translate([0, 25, 14])
    rotate([0, angle + 90, 0])
      angle_joint(angle);
}

module joins_demo() {

  plates = plate_exports();
  h = plates[0];
  h1 = plates[1];
  // joints
  translate([0, 0, 0]) {
    translate([0, 0, h1])
      rotate([90, 0, 0])
        angle_joint(0, 2, 10);

    translate([0, 15, 8.5])
      rotate([90, 0, 0])
        angle_joint(30, 2, 10);

    translate([0, 30, 8.5])
      rotate([90, 0, 0])
        angle_joint(45, 2, 10);

    translate([0, 45, 8.5])
      rotate([90, 0, 0])
        angle_joint(60, 2, 10);

    translate([0, 60, 8.5])
      rotate([90, 0, 0])
        angle_joint(90, 2, 10   );
  }
}
