// Visual test for box.scad: one small, one medium box side by
// side, plus a small box sitting on top of the medium one, to
// confirm the face grids line up across sizes.
include <lib/box.scad>

box_small(units_z = 1);

translate([2 * unit, 0, 0])
    box_medium(units_z = 1);

translate([2 * unit, 0, unit])
    box_small(units_z = 1);
