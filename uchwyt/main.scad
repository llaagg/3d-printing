// Main entry file
// Include clamp and screw modules, then instantiate both parts separately.

include <clamp.scad>
include <screw.scad>


translate([0,0,0])
    supporters(h=16, w=10, t=0.4);
translate([0,40,0])
    supporters(h=16, w=9.5, t=0.4);
translate([0,80,0])
    supporters(h=16, w=9, t=0.4);
translate([0,120,0])
    supporters(h=16, w=8.5, t=0.4);

//clamp();
//Demo();