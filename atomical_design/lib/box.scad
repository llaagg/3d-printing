// ============================================================
// Atomic Design - Box shell
// The physical module: a hollow box, sized in whole `unit`s per
// axis. Every face's rod-hole grid is anchored to the same global
// grid (see grid.scad), so a 1x1x1 box's holes always line up
// with a 3x3x1 or 9x9x1 box's holes - any size bolts to any other.
// ============================================================
include <../params.scad>
include <grid.scad>
include <holes.scad>
include <locking.scad>

// Corner positions shared with panel.scad, so a lid's pins always
// land on the box's sockets. Margin is clamped so the 4 corners
// stay distinct even on a 1-unit box.
function lid_corner_margin(sx, sy) = min(unit / 2, sx / 3, sy / 3);
function lid_corner_xy(sx, sy) =
    let (m = lid_corner_margin(sx, sy))
    [[m, m], [sx - m, m], [m, sy - m], [sx - m, sy - m]];

// Hollow shell, `units_x` x `units_y` x `units_z` units, wall
// thickness `wall`. Open at the top by default (a tray/frame you
// can shape freely - add a lid, a cushion, a tabletop panel...).
// Each `*_holes` flag drills that face's grid with rod_hole()
// (holes.scad) so neighboring modules of any size can be bolted
// together with M8 threaded rod + nut + washer.
// `lid_sockets`, only on an open-top box, adds 4 corner bosses
// with bayonet sockets (locking.scad) so a matching panel() lid
// can be pushed on and twisted to lock, tool-free.
module box(units_x, units_y, units_z,
           open_top = true,
           side_holes = true, bottom_holes = true, top_holes = false,
           lid_sockets = false) {
    sx = units_x * unit;
    sy = units_y * unit;
    sz = units_z * unit;

    union() {
        difference() {
            cube([sx, sy, sz]);

            // hollow out the inside, open at the top unless open_top = false
            translate([wall, wall, open_top ? wall : -0.5])
                cube([sx - 2 * wall, sy - 2 * wall,
                      sz - wall + (open_top ? 0.5 : 1)]);

            // front (y = 0) / back (y = sy)
            if (side_holes) {
                translate([0, 0, sz]) rotate([-90, 0, 0])
                    grid_holes(units_x, units_z, wall);
                translate([0, sy, 0]) rotate([90, 0, 0])
                    grid_holes(units_x, units_z, wall);
            }

            // left (x = 0) / right (x = sx)
            if (side_holes) {
                translate([0, 0, sz]) rotate([0, 90, 0])
                    grid_holes(units_z, units_y, wall);
                translate([sx, 0, 0]) rotate([0, -90, 0])
                    grid_holes(units_z, units_y, wall);
            }

            // bottom (z = 0)
            if (bottom_holes)
                grid_holes(units_x, units_y, wall);

            // top (z = sz), only meaningful on a closed box
            if (top_holes && !open_top)
                translate([0, sy, sz]) rotate([180, 0, 0])
                    grid_holes(units_x, units_y, wall);
        }

        // corner bosses for a bayonet-locked lid (panel.scad)
        if (open_top && lid_sockets)
            for (xy = lid_corner_xy(sx, sy))
                translate([xy[0], xy[1], sz - bayonet_socket_depth])
                    difference() {
                        cylinder(h = bayonet_socket_depth, d = lid_boss_d);
                        bayonet_socket();
                    }
    }
}

// The 3 standard footprints - all share the same face grid, so
// 3x3 small boxes tile one medium footprint, 3x3 medium tile one
// large footprint.
module box_small(units_z = size_small)  { box(size_small,  size_small,  units_z); }
module box_medium(units_z = size_small) { box(size_medium, size_medium, units_z); }
module box_large(units_z = size_small)  { box(size_large,  size_large,  units_z); }
