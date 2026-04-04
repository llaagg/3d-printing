// ==============================
// PARAMETRY
// ==============================
size = 40;          // bok kwadratu (mm)
thickness = 4;      // grubość płytki (mm)

pattern_pitch = 1.2;   // odległość między punktami (mm)
pyramid_height = 0.4;  // wysokość piramid (mm)
pyramid_size = 0.8;    // szerokość podstawy piramidy (mm)

// ==============================
// MODUŁ PIRAMIDKI
// ==============================
module pyramid(h, base) {
    polyhedron(
        points=[
            [0,0,0],
            [base,0,0],
            [base,base,0],
            [0,base,0],
            [base/2, base/2, h]
        ],
        faces=[
            [0,1,4],
            [1,2,4],
            [2,3,4],
            [3,0,4],
            [0,1,2,3]
        ]
    );
}

// ==============================
// GŁÓWNA PŁYTKA + TEKSTURA
// ==============================
union() {
    // baza
    cube([size, size, thickness]);

    // tekstura (na górze)
    for (x = [0 : pattern_pitch : size - pyramid_size]) {
        for (y = [0 : pattern_pitch : size - pyramid_size]) {

            translate([x, y, thickness])
                pyramid(pyramid_height, pyramid_size);
        }
    }
}