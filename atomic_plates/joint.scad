// Snap-fit joint connecting two plates (see plates.scad) along their
// vertical walls. Each joint is a single printed part: a flange on each
// side that seats flush against a wall's outer face, with a barbed tab
// that pushes through a slot cut in that wall and locks behind it.
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
wall      = 4;      // wall thickness of the plates, mm
fit_clear = 0.25;   // per-side clearance between tab and slot, mm — tune after a test print

// slot the tab must pass through — keep these equal to plates.scad's
// joint_slot_w / joint_slot_h ("use" does not import variables across files)
slot_w = 12;
slot_h = 6;

// ---------- barb / snap geometry ----------
barb_h   = 0.9;   // barb overhang past the nominal finger thickness, mm
barb_len = 3.5;   // length of the barb ramp along the insertion axis, mm
shoulder = 0.4;   // length of the steep retention shoulder, mm
slit     = 1.4;   // gap splitting the tab into two independent flexing fingers, mm
lead_in  = 0.6;   // small chamfer at the very tip, mm

// ---------- flange / bridge geometry ----------
flange_t   = 2.5;   // flange thickness against the wall face, mm
flange_pad = 2.5;   // flange overhang beyond the slot on each side, mm
bridge_gap = 10;    // horizontal distance between the two plates' outer wall faces, mm
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

// The flat pad that presses against the wall's outer face (X in [-flange_t, 0]).
module flange_block() {
    translate([-flange_t, -(slot_w/2 + flange_pad), -(slot_h/2 + flange_pad)])
        cube([flange_t, slot_w + 2*flange_pad, slot_h + 2*flange_pad]);
}

// The full joint: two arms + a bridge, bent so the plates end up `fold_deg` apart.
// Arm A stays horizontal (the reference plate); arm B tilts by fold_deg about
// the wall-run axis (Y), matching a plate rotated up out of the flat plane.
module angle_joint(fold_deg, gap = bridge_gap) {
    module armA_xf() { translate([-gap/2, 0, 0]) rotate([0, 0, 180]) children(); }
    module armB_xf() { translate([ gap/2, 0, 0]) rotate([0, fold_deg, 0]) children(); }

    union() {
        hull() {
            armA_xf() flange_block();
            armB_xf() flange_block();
        }
        armA_xf() { flange_block(); snap_tab(); }
        armB_xf() { flange_block(); snap_tab(); }
    }
}

// ============================== output ==============================
/* [Output] */
render_mode = "print";  // [print:standalone joints for printing, demo:assembled plate pair]
demo_fold   = 45;      // [0:15:90] fold angle used by "demo" mode

if (render_mode == "print") {

    fold_angles = [0, 30, 45, 60];
    spacing = 30;
    for (i = [0 : len(fold_angles) - 1])
        translate([0, i * spacing, 0])
            angle_joint(fold_angles[i]);

} else {

    plate_w = 50;
    plate_l = 50;
    plate_h = 15;

    // Plate A: reference, stays flat. Slot in its east wall.
    footprint_box(plate_w, plate_l, plate_h, joints = [["east", 0, 0]]);

    // Plate B: sits across the gap, tilted up by demo_fold about the shared
    // bottom edge so its (west-wall) slot lines up with the joint's arm B.
    hinge_x = plate_w + bridge_gap;
    translate([hinge_x, 0, 0])
        rotate([0, -demo_fold, 0])
            footprint_box(plate_w, plate_l, plate_h, joints = [["west", 0, 0]]);

    // The joint itself, positioned at the slots' shared height.
    translate([plate_w + bridge_gap/2, plate_l/2, plate_h/2])
        angle_joint(demo_fold);
}
