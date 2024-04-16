// Licensed under the terms of CC BY-SA 4.0 DEED
// Attribution-ShareAlike 4.0 International.
// For full licensing terms, see
// https://creativecommons.org/licenses/by-sa/4.0/deed.en

// Used to smooth resulting output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

function display_board_width() = 108;
function display_board_height() = 135;
function display_board_depth() = 3;

// Thickness of box
box_thickness = 1.5;
// Length of notch separating filament boards
notch = 4;
// How many filament boards to contain
hold_count = 2;
// Diamonds? Alternatively, circles
cutouts_diamonds = true;


//translate([4,-4,2])
//rotate([90,0,0])
//translate([-74,-61,-4])
//import("./color_card_board_n1_10_gap15.stl");

module swatch_container_box() {
    difference() {
        cube([
            display_board_width() + 2 + box_thickness * 2,
            box_thickness * (hold_count + 1) + (display_board_depth() + 1) * hold_count,
            display_board_height() + box_thickness
        ]);
        
        translate([box_thickness + notch, box_thickness, box_thickness])
        cube([
            display_board_width() - notch * 2,
            box_thickness * (hold_count - 1) + (display_board_depth() + 1) * hold_count,
            display_board_height() + box_thickness
        ]);
    }
}

module swatch_container_slots() {
    for (i = [1:hold_count])
    translate([
        box_thickness,
        box_thickness * i + (display_board_depth() + 1) * (i - 1),
        box_thickness
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
                translate([26.5 * col - 11 + box_thickness, -1, row * 26 - 11 + box_thickness])
                rotate([-90,90,0])
                cylinder(
                    h = (display_board_depth() + box_thickness * 2) * hold_count + box_thickness + 2,
                    d = 16,
                    $fn = cutouts_diamonds ? 4 : -1
                );
            }
        }
    }
}

difference() {
    swatch_container_box();
    swatch_container_slots();
    swatch_display_holes();
}
