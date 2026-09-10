// ============================================================
// Atomic Design - Fastener primitives
// A single hole design used everywhere: a through clearance hole
// for an M8 threaded rod, with a hex nut + washer pocket on each
// face. Since the rod has no head, both ends are identical - a
// rod can run through any number of stacked walls and gets capped
// with a nut+washer wherever it comes out.
// ============================================================
include <../params.scad>

// Clearance hole for the rod, running along +Z through the wall.
module rod_shaft_hole(depth) {
    translate([0, 0, -0.5])
        cylinder(h = depth + 1, d = rod_d);
}

// Nut + washer pocket, cut from one face (starting at z = z0),
// recessing into the wall so the nut+washer stack sits flush.
module rod_nut_pocket(z0) {
    translate([0, 0, z0])
        cylinder(h = nut_h + 0.5, d = nut_d, $fn = 6);
    translate([0, 0, z0 + nut_h])
        cylinder(h = washer_h + 0.5, d = washer_d);
}

// Full rod joint: shaft through the whole wall, nut+washer pocket
// at each face. `nut_near`/`nut_far` let a mid-wall (e.g. a rib
// the rod merely passes through) skip the pocket on either side.
module rod_hole(depth = wall, nut_near = true, nut_far = true) {
    rod_shaft_hole(depth);
    if (nut_near) rod_nut_pocket(-0.5);
    if (nut_far)  rod_nut_pocket(depth - nut_h - washer_h);
}
