// Main entry file
// Include clamp and screw modules, then instantiate both parts separately.

include <clamp.scad>
include <screw.scad>


translate([0,120,0])
    supporters(h=16, w=8.5, t=0.4);

//clamp();