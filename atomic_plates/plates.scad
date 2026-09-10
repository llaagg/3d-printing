// Parametric footprint test box: closed top, open bottom, thick walls
box_w  = 500;   // mm (50 cm)
box_l  = 500;   // mm (50 cm)
box_h  = 15;    // mm (1.5 cm)

wall   = 4;     // side wall thickness, mm
top_t  = 4;     // top surface thickness, mm

$fn = 32;

module footprint_box() {
    difference() {
        cube([box_w, box_l, box_h]);

        // hollow out interior, leaving top plate and side walls
        // cavity is open at the bottom (extends past z=0)
        translate([wall, wall, -1])
            cube([box_w - 2*wall, box_l - 2*wall, box_h - top_t + 1]);
    }
}

footprint_box();
