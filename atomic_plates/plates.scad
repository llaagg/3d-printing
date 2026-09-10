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

// ---- Joint slot support ----
// Rectangular through-cuts in a wall so a snap-fit joint (see joint.scad)
// can be plugged into the plate. Slots are centered on the wall's height
// by default and placed on the straight (non-rounded) section of the wall.
joint_slot_w = 12;   // slot width along the wall run, mm
joint_slot_h = 6;     // slot height, mm

// side: "north" | "south" | "east" | "west" — which outer wall to cut through
// offset: shift of the slot center along the wall run, from the wall midpoint
// z_offset: shift of the slot center along the wall height, from mid-height
module wall_slot_cut(w, l, h, side, w_slot = joint_slot_w, h_slot = joint_slot_h, offset = 0, z_offset = 0) {
    cut_len = wall + 2;      // through-cut, plus 1mm margin each side
    z_slot  = h/2 + z_offset - h_slot/2;

    if (side == "east")
        translate([w - wall - 1, l/2 + offset - w_slot/2, z_slot])
            cube([cut_len, w_slot, h_slot]);
    else if (side == "west")
        translate([-1, l/2 + offset - w_slot/2, z_slot])
            cube([cut_len, w_slot, h_slot]);
    else if (side == "north")
        translate([w/2 + offset - w_slot/2, l - wall - 1, z_slot])
            cube([w_slot, cut_len, h_slot]);
    else if (side == "south")
        translate([w/2 + offset - w_slot/2, -1, z_slot])
            cube([w_slot, cut_len, h_slot]);
}

// joints: list of [side, offset, z_offset] triples adding a slot cutout each,
// e.g. [["east", 0, 0]]. Defaults to no slots (unchanged behavior).
module footprint_box(w, l, h, joints = []) {
    inner_r = max(corner_r - wall, 0.1);
    difference() {
        rounded_box(w, l, h, corner_r);

        // hollow out interior, leaving top plate and side walls
        // cavity is open at the bottom (extends past z=0)
        translate([wall, wall, -1])
            rounded_box(w - 2*wall, l - 2*wall, h - top_t + 1, inner_r);

        for (j = joints)
            wall_slot_cut(w, l, h, j[0], offset = j[1], z_offset = len(j) > 2 ? j[2] : 0);
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
