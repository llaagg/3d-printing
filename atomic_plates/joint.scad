use <plates.scad>;

plate_w = 50;
plate_l = 50;
plate_h = 15;
gap = 10;

for (i = [0 : 2]) {
	translate([i * (plate_w + gap), 0, 0])
		footprint_box(plate_w, plate_l, plate_h);
}
