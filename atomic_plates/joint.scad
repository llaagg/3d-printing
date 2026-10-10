// Snap-fit joint connecting two plates (see plates.scad) along their
// vertical walls. Each joint is a single printed part: a flange on each
// side seats flush against a wall's outer face, with a barbed tab that
// pushes through a slot cut in that wall and locks behind it.
//
// The two flanges are joined by a bridge whose angle sets the resulting
// fold between the plates once both tabs are snapped in:
//   fold_deg = 0   -> plates stay flat / coplanar (a straight coupler)
//   fold_deg = 30  -> plates open by 30 degrees
//   fold_deg = 45  -> plates open by 45 degrees
//
// Print the "print" layout as-is (no supports normally needed). Use the
// "demo" layout to preview an assembled pair of plates at a given angle.

use <plates.scad>;

$fn = 32;

// ---------- fit parameters (must match plates.scad's wall thickness) ----------
fit_clear = 0.25;   // per-side clearance between tab and slot, mm — tune after a test print

plate_settings = plate_exports();

slot_w = plate_settings[0];
slot_h = plate_settings[1];
wall = plate_settings[2];  //-1
wall_margin = plate_settings[3];

// ---------- barb / snap geometry ----------
barb_h   = 0.9;   // barb overhang past the nominal finger thickness, mm
barb_len = 3.5;   // length of the barb ramp along the insertion axis, mm
shoulder = 0.4;   // length of the steep retention shoulder, mm
slit     = 1.4;   // gap splitting the tab into two independent flexing fingers, mm
lead_in  = 0.6;   // small chamfer at the very tip, mm

// ---------- flange / bridge geometry ----------
flange_t   = wall_margin;   // flange thickness against the wall face, mm
flange_pad = 2;   // flange overhang beyond the slot on each side, mm
reach      = wall + barb_len + 1;  // tab length: through the wall, clear of the barb

// One flexing finger with a one-way barb (2D profile in X-Z, extruded along Y).
// X: 0 = flange face, `reach` = tip. Z: z_bot = inner edge (against the slit).
module barbed_finger(z_bot, finger_h, w) {
    profile = [
        [0, z_bot],
        [0, z_bot + finger_h],
        [reach - barb_len, z_bot + finger_h],
        [reach - barb_len + shoulder, z_bot + finger_h + barb_h],
        [reach - lead_in, z_bot + finger_h],
        [reach, z_bot + finger_h - lead_in],
        [reach, z_bot],
    ];
    translate([0, w/2, 0])
        rotate([90, 0, 0])
            linear_extrude(height = w)
                polygon(profile);
}

// The snap tab: two mirrored fingers (top/bottom) split by a central slit,
// sized to pass through a `slot_w` x `slot_h` hole and lock behind it.
module snap_tab(w = slot_w - 2*fit_clear, h = slot_h - 2*fit_clear) {
    finger_h = (h - slit) / 2;
    barbed_finger(slit/2, finger_h, w);
    mirror([0, 0, 1])
        barbed_finger(slit/2, finger_h, w);
}

function joint_height() = slot_h + 2*flange_pad;

// The flat pad that presses against the wall's outer face (X in [-flange_t, 0]).
module flange_block() {
    translate([-flange_t, -(slot_w/2 + flange_pad), -(slot_h/2 + flange_pad)])
        cube([flange_t, slot_w + 2*flange_pad, joint_height()]);
}

// The full joint: two arms + a bridge, bent so the plates end up `fold_deg` apart.
// Arm A stays horizontal (the reference plate); arm B tilts by fold_deg about
// the wall-run axis (Y), matching a plate rotated up out of the flat plane.
module angle_joint(fold_deg, top_h, h) {
    offset = -top_h - h/2 ;
    
    //translate([0, 0, -t -h/2 + joint_h/2  ])

    module armA_xf() { translate([ -0,  0, 0]) rotate([0, 0, 180]) translate([flange_t, 0,  offset]) children(); }
    module armB_xf() { translate([  0,  0, 0]) rotate([0, -fold_deg, 0]) translate([flange_t, 0, offset]) children(); }

    union() {
        // let's offeset all not center
        // then when we do rotation it's not around center of the object
        
        hull() 
        {
            armA_xf() flange_block();
            armB_xf() flange_block();
        }
        armA_xf() { 
            snap_tab(); 
        }
        armB_xf() {
                snap_tab(); 
        }
    }
}
