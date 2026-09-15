// Złącze zatrzaskowe łączące dwie płytki (zob. plates.scad) wzdłuż ich
// pionowych ścian. Każde złącze to jeden drukowany element: kołnierz po obu
// stronach przylega równo do zewnętrznej powierzchni ściany, a zadziorny języczek
// przechodzi przez wycięty w niej otwór i blokuje się za nim.
//
// Dwa kołnierze są połączone mostkiem, którego kąt ustala końcowe zgięcie
// między płytkami po zatrzaśnięciu obu języczków:
//   fold_deg = 0   -> płytki pozostają płaskie / współpłaszczyznowe (prosty łącznik)
//   fold_deg = 30  -> płytki otwierają się o 30 stopni
//   fold_deg = 45  -> płytki otwierają się o 45 stopni
//
// Wydrukuj układ "print" bez zmian (zwykle nie potrzeba podpór). Użyj układu
// "demo", aby podglądnąć złożoną parę płytek pod zadanym kątem.

use <plates.scad>;

$fn = 32;

// ---------- parametry dopasowania (muszą odpowiadać grubości ściany w plates.scad) ----------
wall      = 3;   // grubość ściany płytek, mm
fit_clear = 0.25;   // luz między języczkiem a slotem po każdej stronie, mm — doreguluj po wydruku testowym

// otwór, przez który musi przejść języczek — utrzymuj to zgodnie z plates.scad
// joint_slot_w / joint_slot_h ("use" nie importuje zmiennych między plikami)
slot_w = 12;
slot_h = 6;

// ---------- geometria zadzioru / zatrzasku ----------
barb_h   = 0.9;   // wysunięcie zadzioru poza nominalną grubość palca, mm
barb_len = 3.5;   // długość rampy zadzioru wzdłuż osi wprowadzania, mm
shoulder = 0.4;   // długość stromej krawędzi utrzymującej, mm
slit     = 1.4;   // szczelina dzieląca języczek na dwa niezależnie sprężyste palce, mm
lead_in  = 0.6;   // mały fazowany najazd na samym czubku, mm

// ---------- geometria kołnierza / mostka ----------
flange_t   = 2.5;   // grubość kołnierza opierającego się o powierzchnię ściany, mm
flange_pad = 2.5;   // wysięg kołnierza poza slot po każdej stronie, mm
bridge_gap = 4;    // pozioma odległość między zewnętrznymi powierzchniami ścian obu płytek, mm
reach      = wall + barb_len + 1;  // długość języczka: przez ścianę, poza zadzior

// Jeden sprężysty palec z jednokierunkowym zadziorem (profil 2D w X-Z, wyciągnięty wzdłuż Y).
// X: 0 = powierzchnia kołnierza, `reach` = czubek. Z: z_bot = krawędź wewnętrzna (przy szczelinie).
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

// Języczek zatrzaskowy: dwa lustrzane palce (góra/dół) rozdzielone centralną szczeliną,
// dopasowane do przejścia przez otwór `slot_w` x `slot_h` i zablokowania się za nim.
module snap_tab(w = slot_w - 2*fit_clear, h = slot_h - 2*fit_clear) {
    finger_h = (h - slit) / 2;
    barbed_finger(slit/2, finger_h, w);
    mirror([0, 0, 1])
        barbed_finger(slit/2, finger_h, w);
}

// Płaska podkładka dociskająca się do zewnętrznej powierzchni ściany (X w [-flange_t, 0]).
module flange_block() {
    translate([-flange_t, -(slot_w/2 + flange_pad), -(slot_h/2 + flange_pad)])
        cube([flange_t, slot_w + 2*flange_pad, slot_h + 2*flange_pad]);
}

// Całe złącze: dwa ramiona + mostek, wygięte tak, by płytki kończyły z odstępem `fold_deg`.
// Ramię A pozostaje poziome (płytka odniesienia); ramię B obraca się o fold_deg wokół
// osi biegnącej wzdłuż ściany (Y), odpowiadając płytce uniesionej z płaszczyzny.
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

// ============================== wyjście ==============================
render_mode = "print";  // "print" -> trzy samodzielne złącza gotowe do krojenia
                        // "demo"  -> jedna złożona para płytek do kontroli wizualnej
demo_fold   = 45;       // kąt zgięcia używany w trybie "demo"

if (render_mode == "print") {

    fold_angles = [0, 30, 45];
    spacing = 30;
    for (i = [0 : len(fold_angles) - 1])
        translate([0, i * spacing, 0])
            angle_joint(fold_angles[i]);

} else {

    plate_w = 50;
    plate_l = 50;
    plate_h = 15;

    // Płytka A: odniesienie, pozostaje płaska. Slot w jej wschodniej ścianie.
    footprint_box(plate_w, plate_l, plate_h, joints = [["east", 0, 0]]);

    // Płytka B: leży po drugiej stronie szczeliny, uniesiona o demo_fold wokół wspólnej
    // dolnej krawędzi, tak aby jej slot (w zachodniej ścianie) pokrył się z ramieniem B złącza.
    hinge_x = plate_w + bridge_gap;
    translate([hinge_x, 0, 0])
        rotate([0, -demo_fold, 0])
            footprint_box(plate_w, plate_l, plate_h, joints = [["west", 0, 0]]);

    // Samo złącze, ustawione na wspólnej wysokości slotów.
    translate([plate_w + bridge_gap/2, plate_l/2, plate_h/2])
        angle_joint(demo_fold);
}
