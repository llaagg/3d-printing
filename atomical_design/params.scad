// ============================================================
// Atomic Design - Global Parameters
// One place to tune the whole system. Every module reads from
// here so all parts stay compatible with each other.
// ============================================================

// --- Grid ---------------------------------------------------
// Everything is built on one "unit" grid. Any face of any box,
// of any size, has its screw holes centered on this same grid,
// so a small box can always be bolted to a bigger one.
unit = 40;              // size of one grid cell [mm]
wall = 3;               // wall thickness of printed shells [mm]

// --- Standard module sizes (in units) ------------------------
// Ratio of 3 between consecutive sizes: 3 small boxes span the
// same length as 1 medium box, 3 medium span 1 large box.
size_small  = 1;   // 1 unit  -> 40  mm
size_medium = 3;   // 3 units -> 120 mm
size_large  = 9;   // 9 units -> 360 mm

// --- Fasteners: M8 threaded rod (varilla roscada) -------------
// Off-the-shelf hardware from any Home Depot / Leroy Merlin:
// a length of M8 threaded rod, cut to size, with a nut + washer
// on each end. No screw heads to fit, no printed threads needed -
// works through any number of stacked walls.
rod_d       = 8.6;    // clearance hole diameter for M8 rod
washer_d    = 17;     // M8 washer OD + clearance
washer_h    = 1.8;    // M8 washer thickness + clearance
nut_d       = 14.8;   // M8 hex nut, corner-to-corner + clearance
nut_h       = 7.2;    // M8 nut thickness + clearance (fits a washer on top)

// --- Bayonet twist-lock (tool-free, printed-only joint) --------
// Insert the pin straight in, twist to lock it under a roof -
// no hardware needed. Good for quick assembly / positioning;
// combine with rod joints where a rigid, permanent joint matters.
bayonet_shaft_d   = 10;   // pin shank diameter
bayonet_clear     = 0.4;  // radial clearance, shaft & lugs
bayonet_lug_w     = 4;    // lug reach beyond the shaft (radial) [mm]
bayonet_lug_h     = 3;    // lug height, along the pin axis [mm]
bayonet_lug_angle = 40;   // angular width of each lug / entry slot [deg]
bayonet_twist     = 35;   // twist angle to lock [deg]
bayonet_floor_h   = 4;    // solid floor below the lock pocket, and the
                          // pin's straight shaft length below its lugs [mm]
bayonet_roof_h    = 3;    // solid roof above the lock pocket once locked [mm]
lid_boss_d = bayonet_shaft_d + 2 * bayonet_lug_w + 6;  // corner boss OD, box.scad/panel.scad

// --- Misc ------------------------------------------------------
$fn = 48;              // circle smoothness for previews/renders
