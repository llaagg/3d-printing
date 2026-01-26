// Moon base stand using cylinder primitives
outer_d = 72; // mm
wall_thickness = 1; // mm
height = 26 + 4; // mm
base_thickness = 1; // mm
inner_cylinder_d = 65; // mm (62 mm internal diameter)
inner_height = 15; // mm
beam_d = 10; // mm
beam_h = 2; // mm

inner_d = inner_cylinder_d - 2 * wall_thickness;


module beam(){

    // Flat beam on top spanning across the diameter
    translate([0, 0, height - beam_h/2 - 4])
        cube([outer_d-1, beam_d, beam_h], center=true);
}


module box(){
    difference(){
        cylinder(h=height, d=outer_d);
       
        
        translate([0, 0, height/2])
			cylinder(
					h=height + 2, 
					d=outer_d - 2 * wall_thickness);
			
        translate([0, 0, -1])
            cylinder(h=inner_height+2, d=inner_d);
    }
}

box();
beam();
