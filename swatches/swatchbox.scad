// Licensed under the terms of CC BY-SA 4.0 DEED
// Attribution-ShareAlike 4.0 International.
// For full licensing terms, see
// https://creativecommons.org/licenses/by-sa/4.0/deed.en

// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

//translate([4,-4,2])
//rotate([90,0,0])
//translate([-74,-61,-4])
//import("./color_card_board_n1_10_gap15.stl");

function display_board_width() = 108;
function display_board_height() = 135;
function display_board_depth() = 3;
board_gap = 1.5;
notch = 4;
hold_count = 2;
cutouts_hexagons = true;

module swatch_container_box() {
    difference() {
        cube([
//            display_board_width() + (board_gap + notch) * 2,
            display_board_width() + 2 + board_gap * 2,
            board_gap * (hold_count + 1) + (display_board_depth() + 1) * hold_count,
            display_board_height() + board_gap
        ]);
        
        translate([board_gap + notch, board_gap, board_gap])
        cube([
            display_board_width() - notch * 2,
            board_gap * (hold_count - 1) + (display_board_depth() + 1) * hold_count,
            display_board_height() + board_gap
        ]);
    }
}

module swatch_container_slots() {
    for (i = [1:hold_count])
    translate([
        board_gap,
        board_gap * i + (display_board_depth() + 1) * (i - 1),
        board_gap
    ]) cube([
        display_board_width() + 2,
        display_board_depth() + 1,
        display_board_height() + 0.01
    ]);
}

module swatch_display_holes() {
    union() {
        for (row = [1:5]) {
            for (col = [1:4]) {
                translate([26.5 * col - 12 + board_gap, -1, row * 26 - 12 + board_gap])
                rotate([-90,90,0])
                cylinder(
                    h = (display_board_depth() + board_gap * 2) * hold_count + board_gap + 2,
                    d = 16,
                    $fn = cutouts_hexagons ? 6 : -1
                );
            }
        }
    }
}

difference() {
    swatch_container_box();
    swatch_container_slots();
    swatch_display_holes();
    translate([0,-5,52])
    cube([150,150,150]);
}
