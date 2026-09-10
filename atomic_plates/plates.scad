// Parametric footprint test box: closed top, open bottom, thick walls
wall   = 4;     // side wall thickness, mm
top_t  = 4;     // top surface thickness, mm
corner_r = 8;   // outer corner rounding radius, mm (must be > wall for inside to round too)
gap    = 10;    // spacing between boxes, mm

$fn = 32;

// rounded rectangular prism, corners rounded on the xy plane only
module rounded_box(w, l, h, r) {
    linear_extrude(height = h)
        hull() {
            for (x = [r, w - r], y = [r, l - r])
                translate([x, y]) circle(r = r);
        }
}

module footprint_box(w, l, h) {
    inner_r = max(corner_r - wall, 0.1);
    difference() {
        rounded_box(w, l, h, corner_r);

        // hollow out interior, leaving top plate and side walls
        // cavity is open at the bottom (extends past z=0)
        translate([wall, wall, -1])
            rounded_box(w - 2*wall, l - 2*wall, h - top_t + 1, inner_r);
    }
}

// box sizes in mm (w, l, h), converted from cm
sizes = [
    [50,  50,  15],   // 5 x 5 x 1.5 cm
    //[100, 100, 15],   // 10 x 10 x 1.5 cm
   // [200, 200, 15],   // 20 x 20 x 1.5 cm
];

for (i = [0 : len(sizes) - 1]) {
    x = sum([for (j = [0 : i - 1]) sizes[j][0] + gap]);
    translate([x, 0, 0])
        footprint_box(sizes[i][0], sizes[i][1], sizes[i][2]);
}
