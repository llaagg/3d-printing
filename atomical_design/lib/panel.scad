// ============================================================
// Atomic Design - Panel / lid
// A flat plate sized to a box's footprint, with bayonet pins on
// the underside at the same 4 corners as box(..., lid_sockets=true)
// - push it on, twist to lock. Use it as a lid, a shelf, or (with
// a thicker `thickness`) a tabletop.
// ============================================================
include <../params.scad>
include <locking.scad>
include <box.scad>  // for lid_corner_xy(), shared with box(..., lid_sockets=true)

module panel(units_x, units_y, thickness = wall, pins = true) {
    sx = units_x * unit;
    sy = units_y * unit;

    union() {
        cube([sx, sy, thickness]);

        if (pins)
            for (xy = lid_corner_xy(sx, sy))
                translate([xy[0], xy[1], -bayonet_floor_h])
                    bayonet_pin();
    }
}
