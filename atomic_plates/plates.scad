// Parametric footprint test box: closed top, open bottom, thick walls
wall   = 4;     // side wall thickness, mm (inner edge is 5 mm closer to center)
wall_margin = 2;   // margin from the outside edge, mm
top_t  = 4;     // top surface thickness, mm
corner_r = 8;   // outer corner rounding radius, mm (must be > wall for inside to round too)
gap    = 10;    // spacing between boxes, mm

$fn = 32;

// rounded rectangular prism, corners rounded on the xy plane only
module rounded_box(w, l, h, r, m = wall_margin) {
    linear_extrude(height = h)
        hull() {
            for (x = [r + m, w - r - m], y = [r + m, l - r - m])
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
module wall_slot_cut(w, l, h, side, w_slot = joint_slot_w, h_slot = joint_slot_h, offset = 0, z_offset = 0, m_margin = wall_margin) {
    
    cut_len = wall + m_margin;      // through-cut, plus 1mm margin each side
    z_slot  = h/2 + z_offset - h_slot/2;

    // offset by wall amrign
    cut_len = wall + m_margin;      // through-cut, plus 1mm margin each side
    if (side == "east")
        translate([w - wall - m_margin -1 , l/2 + offset - w_slot/2, z_slot])
            cube([cut_len, w_slot, h_slot]);
    else if (side == "west")
        translate([m_margin-1, l/2 + offset - w_slot/2, z_slot])
            cube([cut_len, w_slot, h_slot]);
    else if (side == "north")
        translate([w/2 + offset - w_slot/2, l - wall - m_margin -1, z_slot])
            cube([w_slot, cut_len, h_slot]);
    else if (side == "south")
        translate([w/2 + offset - w_slot/2, +m_margin-1, z_slot])
            cube([w_slot, cut_len, h_slot]);
}

// Build the separate top plane. It sits on top of the wall section when split.
module plate_top(w, l, top_height = top_t) {
    rounded_box(w, l, top_height, corner_r,0 );
}

// Optional helper for prints that overfill the top edge by a small amount.
// The trim affects only the crown: the lower body keeps the full footprint,
// and the topmost layer is inset slightly around the edge.
module plate_top_trimmed(w, l, top_height = top_t, trim = 0.1) {
    crown_h = min(trim, top_height);
    body_h = max(top_height - crown_h, 0.01);
    inset_w = max(w - 2 * trim, 0.01);
    inset_l = max(l - 2 * trim, 0.01);
    inset_r = max(corner_r - trim, 0.01);

    union() {
        rounded_box(w, l, body_h, corner_r, 0);
        translate([trim, trim, body_h])
            rounded_box(inset_w, inset_l, crown_h, inset_r, 0);
    }
}

// Build the open-bottom wall section. The wall section ends at the underside
// of the separate top plane.
module plate_walls(w, l, wall_height, joints = [], slot_height = wall_height) {
    inner_r = max(corner_r - wall, 0.1);
    difference() {
        rounded_box(w, l, wall_height, corner_r);
        translate([wall, wall, -1])
            // Extend beyond the top so the wall section stays open.
            rounded_box(w - 2*wall, l - 2*wall, wall_height + 2, inner_r);
        for (j = joints)
                wall_slot_cut(w, l, slot_height, j[0], offset = j[1], z_offset = len(j) > 2 ? j[2] : 0);
            
    }
}

// joints: list of [side, offset, z_offset] triples adding a slot cutout each,
// e.g. [["east", 0, 0]]. Defaults to no slots (unchanged behavior).
// top_trim: optional crown trim in mm for over-extrusion compensation.
module footprint_box(w, l, h, joints = [], top_trim = 0) {
    wall_height = h ;
    plate_walls(w, l, wall_height, joints, slot_height = h);
    translate([0, 0, wall_height])
        if (top_trim > 0)
            plate_top_trimmed(w, l, top_t, top_trim);
        else
            plate_top(w, l, top_t);
}

// box sizes in mm (w, l, h), converted from cm
sizes = [
    [50,  50,  15],   // 5 x 5 x 1.5 cm
    //[100, 100, 15],   // 10 x 10 x 1.5 cm
   // [200, 200, 15],   // 20 x 20 x 1.5 cm
];

// "combined" keeps the assembled plate; "top" and "walls" export one part;
// "split" lays both parts out side by side for printing.
render_mode = "walls";
split_gap = 10;

for (i = [0 : len(sizes) - 1]) {
    x = sum([for (j = [0 : i - 1]) sizes[j][0] + gap]);
    w = sizes[i][0];
    l = sizes[i][1];
    h = sizes[i][2];
    wall_height = h - top_t;

    translate([x, 0, 0]) {
        if (render_mode == "combined")
            footprint_box(w, l, h);
        else if (render_mode == "top")
            plate_top(w, l, top_t);
        else if (render_mode == "top_trimmed")
            plate_top_trimmed(w, l, top_t, 0.1);
        else if (render_mode == "walls")
            plate_walls(w, l, wall_height);
        else if (render_mode == "split") {
            plate_walls(w, l, wall_height);
            translate([w + split_gap, 0, 0])
                plate_top(w, l, top_t);
        }
    }
}
