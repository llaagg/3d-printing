// Domek do wydruku 3D
// Parametry można dostosować według potrzeb

// ===== PARAMETRY =====
wall_thickness = 2;      // Grubość ścian
house_width = 60;        // Szerokość domku
house_depth = 50;        // Głębokość domku
house_height = 40;       // Wysokość ścian
roof_height = 30;        // Wysokość dachu
door_width = 15;         // Szerokość drzwi
door_height = 25;        // Wysokość drzwi
window_width = 10;       // Szerokość okna
window_height = 10;      // Wysokość okna

// ===== FUNKCJE POMOCNICZE =====
module walls() {
    difference() {
        // Zewnętrzne ściany
        cube([house_width, house_depth, house_height]);
        
        // Wydrążenie wewnątrz
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([
                house_width - 2*wall_thickness,
                house_depth - 2*wall_thickness,
                house_height
            ]);
    }
}

module door() {
    translate([house_width/2 - door_width/2, -0.1, 0])
        cube([door_width, wall_thickness + 0.2, door_height]);
}

module window(x, y) {
    translate([x, y, house_height/2])
        cube([window_width, wall_thickness + 0.2, window_height], center=true);
}

module roof() {
    translate([house_width/2, house_depth/2, house_height]) {
        rotate([90, 0, 0])
            linear_extrude(height=house_depth, center=true)
                polygon([
                    [-house_width/2 - 5, 0],
                    [house_width/2 + 5, 0],
                    [0, roof_height]
                ]);
    }
}

// ===== BUDOWA DOMKU =====
difference() {
    union() {
        // Ściany
        walls();
        
        // Dach
        difference() {
            roof();
            // Wydrążenie dachu
            translate([house_width/2, house_depth/2, house_height + wall_thickness])
                rotate([90, 0, 0])
                    linear_extrude(height=house_depth - 2*wall_thickness, center=true)
                        polygon([
                            [-house_width/2 - 3, 0],
                            [house_width/2 + 3, 0],
                            [0, roof_height - wall_thickness]
                        ]);
        }
    }
    
    // Drzwi
    door();
    
    // Okna - przednie ściana (po bokach drzwi)
    window(house_width/4, -0.1);
    window(3*house_width/4, -0.1);
    
    // Okna - boczne ściany
    window(-0.1, house_depth/3);
    window(-0.1, 2*house_depth/3);
    window(house_width - wall_thickness + 0.1, house_depth/3);
    window(house_width - wall_thickness + 0.1, 2*house_depth/3);
    
    // Okno - tylna ściana
    window(house_width/2, house_depth - wall_thickness + 0.1);
}
