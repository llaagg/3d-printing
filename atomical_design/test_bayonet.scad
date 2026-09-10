// Visual test for the bayonet twist-lock: a socket block on the
// left, a pin block on the right, and a locked assembly in the
// middle (pin twisted `bayonet_twist` degrees into the socket).
include <lib/locking.scad>

boss_d = bayonet_shaft_d + 2 * bayonet_lug_w + 6;

module socket_block(twist_preview = 0) {
    difference() {
        cylinder(h = bayonet_socket_depth, d = boss_d);
        rotate([0, 0, twist_preview])
            bayonet_socket();
    }
}

// left: empty socket
translate([-40, 0, 0])
    socket_block();

// right: bare pin, tip up for inspection
translate([40, 0, 0])
    bayonet_pin();

// middle: assembled + twisted to the locked position
translate([0, 40, 0]) {
    color("lightgray") socket_block(bayonet_twist);
    color("orange") bayonet_pin();
}

// middle-lower: cutaway of the locked joint (half-section)
translate([0, -40, 0])
    difference() {
        union() {
            color("lightgray") socket_block(bayonet_twist);
            color("orange") bayonet_pin();
        }
        translate([-boss_d, 0, -1])
            cube([boss_d, boss_d, bayonet_socket_depth + 2]);
    }
