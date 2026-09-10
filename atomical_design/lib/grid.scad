// ============================================================
// Atomic Design - Grid helpers
// The universal alignment grid shared by every part.
// ============================================================
include <../params.scad>

// Centers of the grid cells along one axis of length `units` cells.
function grid_centers(units) = [for (i = [0 : units - 1]) i * unit + unit / 2];

// Places `rod_hole()` (must be included by the caller) at every
// grid cell center on a flat rectangle of size (units_a x units_b),
// lying in the local XY plane, hole axis along local +Z.
module grid_holes(units_a, units_b, depth, nut_near = true, nut_far = true) {
    for (a = grid_centers(units_a))
        for (b = grid_centers(units_b))
            translate([a, b, 0])
                rod_hole(depth = depth, nut_near = nut_near, nut_far = nut_far);
}
