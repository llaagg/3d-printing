// Main entry file
// Include clamp and screw modules, then instantiate both parts separately.

include <clamp.scad>
include <screw.scad>

// Show clamp and screw separately in the same scene:
//clamp();
translate([40,0,0])
    screw(w=10, h=20);

translate([-40,0,0])
    ballCatcher(w=10);

// Uncomment to show only one at a time:
//clamp();
//screw();
