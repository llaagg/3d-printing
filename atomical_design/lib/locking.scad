// ============================================================
// Atomic Design - Bayonet twist-lock
// A tool-free, printed-only joint: push the pin straight in,
// twist it `bayonet_twist` degrees, and it locks under a solid
// roof - no hardware needed. Use it for quick assembly/alignment;
// combine with rod_hole() (holes.scad) where a joint must also
// resist heavy pulling loads.
//
// Geometry (all measured from the socket's outer/entry face,
// z = depth, down to its inner face, z = 0):
//   - a plain round bore runs the full depth, so the shaft can
//     always rotate freely;
//   - two straight entry slots (at 0*/180*) let the pin's lugs
//     drop straight in, from the entry face down past the lock
//     pocket, so the lug can travel all the way to its resting
//     depth (`bayonet_floor_h` above the inner face);
//   - two lock pockets sit right at that resting depth, offset
//     by `bayonet_twist`, so twisting slides the lugs sideways
//     into a pocket capped by a solid roof of thickness
//     `bayonet_roof_h` - that roof is what stops the pin pulling
//     back out.
// ============================================================
include <../params.scad>

bayonet_socket_depth = bayonet_roof_h + bayonet_lug_h + bayonet_floor_h;

// Solid pin, printed on the male half of the joint. Tip at z = 0.
module bayonet_pin(shaft_h = bayonet_floor_h) {
    d = bayonet_shaft_d;
    cylinder(h = shaft_h, d = d);
    translate([0, 0, shaft_h])
        for (a = [0, 180])
            rotate([0, 0, a])
                intersection() {
                    cylinder(h = bayonet_lug_h, d = d + 2 * bayonet_lug_w);
                    rotate([0, 0, -bayonet_lug_angle / 2])
                        rotate_extrude(angle = bayonet_lug_angle)
                            square([d / 2 + bayonet_lug_w, bayonet_lug_h]);
                }
}

// Cavity to cut from the female half. `depth` is the thickness of
// the boss/wall the socket sits in (must be >= bayonet_socket_depth).
module bayonet_socket(depth = bayonet_socket_depth) {
    d    = bayonet_shaft_d;
    clr  = bayonet_clear;
    r_lug = d / 2 + bayonet_lug_w + clr;

    // round bore for the shaft, free to rotate at any angle
    translate([0, 0, -0.5])
        cylinder(h = depth + 1, d = d + 2 * clr);

    // straight slots: let the lugs drop all the way past the lock
    // pocket, down to their resting depth (bayonet_floor_h)
    for (a = [0, 180])
        rotate([0, 0, a - bayonet_lug_angle / 2])
            translate([0, 0, depth - bayonet_roof_h - bayonet_lug_h])
                rotate_extrude(angle = bayonet_lug_angle)
                    square([r_lug, bayonet_roof_h + bayonet_lug_h + 0.5]);

    // lock pockets: contiguous with the entry slots, extended by
    // the twist angle, capped above by a solid roof (= roof_h)
    for (a = [0, 180])
        rotate([0, 0, a - bayonet_lug_angle / 2])
            translate([0, 0, depth - bayonet_roof_h - bayonet_lug_h])
                rotate_extrude(angle = bayonet_lug_angle + bayonet_twist)
                    square([r_lug, bayonet_lug_h]);
}
