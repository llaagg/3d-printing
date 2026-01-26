// Low Poly Tree for 3D Printing - Phase 1: Trunk
// 30cm tall oak-like tree trunk with hollow core for RGB LED strip

// ===== PARAMETERS =====
tree_height = 250; // 30cm in mm
trunk_base_diameter = 50;
trunk_top_diameter = 25;
led_channel_diameter = 8; // for LED strip
wall_thickness = 0.4; // minimum wall thickness for LED channel

// Randomization seed (change for different trunk variations)
random_seed = 42;

// Quality settings
$fn = 8; // Low poly look (8 sides for cylinders)

// ===== RANDOMIZATION HELPERS =====
function rand(index, seed) = 
    (sin(index * 12.9898 + seed * 78.233) * 43758.5453) - floor(sin(index * 12.9898 + seed * 78.233) * 43758.5453);

// Sum function for accumulating values
function sum(v, i = 0, r = 0) = i < len(v) ? sum(v, i + 1, r + v[i]) : r;

// Get number of segments (3-7)
function get_segment_count(seed) = 
    floor(3 + rand(0, seed) * 5); // 3 to 7 segments

// ===== MODULES =====

// Create an irregular oak-like trunk section
module trunk_section(height, bottom_d, top_d, x_offset=0, y_offset=0) {
    translate([x_offset, y_offset, 0])
        cylinder(h=height, d1=bottom_d, d2=top_d);
}

// Create the main trunk with LED channel
module trunk() {
    num_segments = get_segment_count(random_seed);
    segment_height = tree_height / num_segments;
    
    difference() {
        union() {
            // Create segments procedurally with accumulated positions
            for (i = [0:num_segments-1]) {
                z_pos = i * segment_height;
                progress = i / num_segments; // 0 to 1
                
                // Calculate diameter at this segment
                segment_bottom_d = trunk_base_diameter * (1 - progress * 0.5);
                segment_top_d = trunk_base_diameter * (1 - (progress + 1/num_segments) * 0.5);
                
                // Calculate accumulated position - sum all previous offsets
                x_accum = sum([for (j = [0:i]) rand(j * 2 + 100, random_seed) * 3 - 1.5]);
                y_accum = sum([for (j = [0:i]) rand(j * 3 + 200, random_seed) * 3 - 1.5]);
                
                // Random diameter variation
                d_variation = 0.95 + rand(i * 5, random_seed) * 0.1; // 0.95 to 1.05
                
                translate([0, 0, z_pos])
                    trunk_section(segment_height, 
                                segment_bottom_d * d_variation, 
                                segment_top_d * d_variation, 
                                x_accum, y_accum);
            }
        }
        
        // Inner channel for LED strip - follows trunk curve
        for (i = [0:num_segments-1]) {
            z_pos = i * segment_height;
            x_accum = sum([for (j = [0:i]) rand(j * 2 + 100, random_seed) * 3 - 1.5]);
            y_accum = sum([for (j = [0:i]) rand(j * 3 + 200, random_seed) * 3 - 1.5]);
            
            translate([trunk_base_diameter/2 - led_channel_diameter/2 - wall_thickness + x_accum, y_accum, z_pos - 0.5])
                cylinder(h=segment_height + 1, d=led_channel_diameter);
        }
    }
}

// ===== RENDER =====
trunk();
