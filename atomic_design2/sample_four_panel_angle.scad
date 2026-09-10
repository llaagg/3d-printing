// Four-panel assembly example
// Panels remain flat in Z and change direction around vertical hinge pins.

use <atomic_design_reference_box.scad>;

panel_pitch = 50;
panel_half_pitch = panel_pitch / 2;
first_joint_x = panel_half_pitch;
second_joint_x = first_joint_x + panel_pitch * cos(35);
second_joint_y = panel_pitch * sin(35);
third_joint_x = second_joint_x + panel_pitch * cos(-35);
third_joint_y = second_joint_y + panel_pitch * sin(-35);

// Panel 1: reference orientation.
atomic_design_panel();

// Panel 2: rotate 35 degrees around the first joint.
translate([first_joint_x, 0, 0]) {
    rotate([0, 0, 35]) {
        translate([panel_half_pitch, 0, 0]) {
            atomic_design_panel();
        }
    }
}

// Panel 3: rotate back by 35 degrees around the second joint.
translate([second_joint_x, second_joint_y, 0]) {
    rotate([0, 0, -35]) {
        translate([panel_half_pitch, 0, 0]) {
            atomic_design_panel();
        }
    }
}

// Panel 4: return to the reference orientation at the third joint.
translate([third_joint_x, third_joint_y, 0]) {
    translate([panel_half_pitch, 0, 0]) {
        atomic_design_panel();
    }
}
