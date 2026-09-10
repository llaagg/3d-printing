// Atomic design reference box
// Dimensions: 50 mm x 50 mm x 15 mm

width = 50;
depth = 50;
height = 15;
corner_radius = 5;
wall_thickness = 3;
bottom_thickness = 3;
hinge_outer_radius = 4;
hinge_female_outer_radius = 6;
hinge_pin_radius = 1.6;
hinge_clearance = 0.25;
hinge_gap = 0.35;
resolution = 64;

$fn = resolution;

// A rounded footprint extruded through the full height keeps the rim and
// bottom flat while leaving sturdy rounded vertical corners.
module rounded_footprint(footprint_width, footprint_depth, footprint_radius) {
	hull() {
		for (x = [footprint_radius, footprint_width - footprint_radius]) {
			for (y = [footprint_radius, footprint_depth - footprint_radius]) {
				translate([x, y]) {
					circle(r = footprint_radius);
				}
			}
		}
	}
}

module panel_shell() {
	translate([-width / 2, -depth / 2, -height / 2]) {
		difference() {
			linear_extrude(height = height) {
				rounded_footprint(width, depth, corner_radius);
			}

			translate([wall_thickness, wall_thickness, bottom_thickness]) {
				linear_extrude(height = height - bottom_thickness + 0.1) {
					rounded_footprint(
						width - 2 * wall_thickness,
						depth - 2 * wall_thickness,
						corner_radius - wall_thickness
					);
				}
			}
		}
	}
}

// Panels join edge-to-edge while their flat bottom surfaces rest on a plane.
// The vertical pin hinge lets each neighboring panel rotate in that plane,
// so the assembly can remain flat or form angled shapes.
// Each panel has a male hinge knuckle on the right edge and two female
// knuckles on the left edge. Identical panels join with a vertical pin.
module male_hinge() {
	translate([width / 2, 0, -height / 2 + hinge_gap]) {
		difference() {
			cylinder(
				r = hinge_outer_radius,
				h = height - 2 * hinge_gap
			);
			cylinder(
				r = hinge_pin_radius + hinge_clearance,
				h = height - 2 * hinge_gap + 0.2
			);
		}
	}
}

module female_knuckle(z_position, knuckle_height) {
	translate([-width / 2, 0, z_position]) {
		difference() {
			cylinder(r = hinge_female_outer_radius, h = knuckle_height);
			cylinder(
				r = hinge_outer_radius + hinge_clearance,
				h = knuckle_height + 0.2
			);
		}
	}
}

module female_hinge() {
	knuckle_height = (height - 3 * hinge_gap) / 2;
	female_knuckle(-height / 2 + hinge_gap, knuckle_height);
	female_knuckle(height / 2 - hinge_gap - knuckle_height, knuckle_height);
}

module atomic_design_panel() {
	panel_shell();
	male_hinge();
	female_hinge();
}

atomic_design_panel();
