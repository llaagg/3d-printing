use <plates.scad>;
use <joint.scad>;


sizes = plate_exports();

demo90(90);


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

module printDemo() {
  translate([60, 60, 0])
    showTwoPlates(90);
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
