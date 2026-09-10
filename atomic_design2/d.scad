//
// MODULAR PANEL SYSTEM
//
// Sizes:
//   S = 50 x 50 x 15 mm
//   M = 100 x 100 x 15 mm
//   L = 250 x 250 x 15 mm
//
// Units: mm
//

$fn = 48;


// ============================================================
// PARAMETERS
// ============================================================

WALL        = 2.0;
TOP         = 0.0;
BOTTOM      = 0.0;

CORNER_R    = 4.0;

PANEL_H     = 15;

// Connector
JOIN_W      = 10;
JOIN_H      = 5;
JOIN_DEPTH  = 5;

CLEARANCE   = 0.25;

DOVETAIL_HEAD_W = 7;
DOVETAIL_BASE_W = 10;

RIB          = 2;
RIB_H        = 7;


// ============================================================
// BASIC GEOMETRY
// ============================================================

module rounded_rect(w, d, r)
{
    hull()
    {
        translate([r, r])
            circle(r);

        translate([w-r, r])
            circle(r);

        translate([r, d-r])
            circle(r);

        translate([w-r, d-r])
            circle(r);
    }
}


// ============================================================
// PANEL OUTER SHELL
// ============================================================

module panel_shell(size)
{
    difference()
    {
        // Outer body
        linear_extrude(PANEL_H)
            rounded_rect(size, size, CORNER_R);

        // Hollow interior. TOP = 0 and BOTTOM = 0 leave both faces open.
        translate([WALL, WALL, BOTTOM])
            linear_extrude(PANEL_H - TOP - BOTTOM)
                rounded_rect(
                    size - 2*WALL,
                    size - 2*WALL,
                    max(0.5, CORNER_R-WALL)
                );
    }
}


// ============================================================
// INTERNAL RIBS
// ============================================================

module ribs(size)
{
    // Cross ribs every 25 mm
    for (x = [25 : 25 : size-25])
    {
        translate([x-RIB/2, WALL, BOTTOM])
            cube([
                RIB,
                size-2*WALL,
                RIB_H
            ]);
    }

    for (y = [25 : 25 : size-25])
    {
        translate([WALL, y-RIB/2, BOTTOM])
            cube([
                size-2*WALL,
                RIB,
                RIB_H
            ]);
    }
}


// ============================================================
// DOVETAIL MALE
// ============================================================

module male_join()
{
    // Horizontal dovetail tongue
    hull()
    {
        translate([-JOIN_DEPTH, -DOVETAIL_HEAD_W/2])
            cube([JOIN_DEPTH, DOVETAIL_HEAD_W, JOIN_H]);

        translate([0, -DOVETAIL_BASE_W/2])
            cube([JOIN_DEPTH, DOVETAIL_BASE_W, JOIN_H]);
    }
}


// ============================================================
// DOVETAIL FEMALE
// ============================================================

module female_join()
{
    // Female cavity
    hull()
    {
        translate([
            -CLEARANCE,
            -DOVETAIL_HEAD_W/2-CLEARANCE
        ])
            cube([
                JOIN_DEPTH + CLEARANCE*2,
                DOVETAIL_HEAD_W + CLEARANCE*2,
                JOIN_H + CLEARANCE*2
            ]);

        translate([
            -CLEARANCE,
            -DOVETAIL_BASE_W/2-CLEARANCE
        ])
            cube([
                JOIN_DEPTH + CLEARANCE*2,
                DOVETAIL_BASE_W + CLEARANCE*2,
                JOIN_H + CLEARANCE*2
            ]);
    }
}


// ============================================================
// EDGE JOIN
//
// connector is placed INSIDE the nominal footprint.
// half of the dovetail is recessed into the panel.
// ============================================================

module male_edge(size, side="right", pos=25)
{
    if (side=="right")
        translate([size, pos, BOTTOM+4])
            rotate([0,90,0])
                male_join();

    if (side=="left")
        translate([0, pos, BOTTOM+4])
            rotate([0,-90,0])
                male_join();

    if (side=="top")
        translate([pos, size, BOTTOM+4])
            rotate([-90,0,0])
                male_join();

    if (side=="bottom")
        translate([pos, 0, BOTTOM+4])
            rotate([90,0,0])
                male_join();
}


module female_edge(size, side="right", pos=25)
{
    if (side=="right")
        translate([size, pos, BOTTOM+4])
            rotate([0,90,0])
                female_join();

    if (side=="left")
        translate([0, pos, BOTTOM+4])
            rotate([0,-90,0])
                female_join();

    if (side=="top")
        translate([pos, size, BOTTOM+4])
            rotate([-90,0,0])
                female_join();

    if (side=="bottom")
        translate([pos, 0, BOTTOM+4])
            rotate([90,0,0])
                female_join();
}


// ============================================================
// CONNECTOR PATTERN
//
// 25 mm grid.
//
// Small 50 mm panel:
//   connectors at 25
//
// Medium 100 mm panel:
//   connectors at 25, 75
//
// Large 250 mm panel:
//   connectors at 25,75,125,175,225
//
// This means:
//
//   50 + 50 = 100
//
// and:
//
//   50 + 50 + 50 + 50 = 100 + 100
//
// etc.
// ============================================================

module female_connectors(size)
{
    for (p = [25 : 50 : size-25])
    {
        female_edge(size, "left", p);
        female_edge(size, "bottom", p);
    }
}

module male_connectors(size)
{
    for (p = [25 : 50 : size-25])
    {
        male_edge(size, "right", p);
        male_edge(size, "top", p);
    }
}


// ============================================================
// PANEL
//
// connector pattern alternates male/female.
// This makes every edge usable.
// ============================================================

module panel(size)
{
    difference()
    {
        union()
        {
            panel_shell(size);
            ribs(size);
        }

        // Female connectors
        //
        female_connectors(size);
    }

    // Male connectors
    //
    male_connectors(size);
}


// ============================================================
// SIMPLE PANEL VARIANTS
// ============================================================

module small()
{
    panel(50);
}

module medium()
{
    panel(100);
}

module large()
{
    panel(250);
}


// ============================================================
// PREVIEW
// ============================================================

// Preview mode: choose one option.
preview = "four_small";

if (preview == "small")
    small();

if (preview == "medium")
    medium();

if (preview == "large")
    large();

// Four 50 mm panels: two by two, using the 25 mm connector grid.
if (preview == "four_small")
{
    small();
    translate([50, 0, 0])
        small();
    translate([0, 50, 0])
        small();
    translate([50, 50, 0])
        small();
}


// Example medium:
//
// translate([0,0,0])
//     medium();


// Example large:
//
// translate([0,0,0])
//     large();