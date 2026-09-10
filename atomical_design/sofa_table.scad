// Sofa table: a large pedestal box with a bayonet-locked tabletop.
include <lib/box.scad>
include <lib/panel.scad>

pedestal_units_z = 6;   // 6 units tall = 240 mm

box(size_large, size_large, pedestal_units_z, open_top = true, lid_sockets = true);

translate([0, 0, pedestal_units_z * unit])
    panel(size_large, size_large, thickness = 2 * wall);
