//translate([4,-4,2])
//rotate([90,0,0])
//translate([-74,-61,-4])
//import("./color_card_board_n1_10_gap15.stl");

function display_board_width() = 108;
function display_board_height() = 135;
function display_board_depth() = 3;
board_gap = 2;

hold_count = 5;

module swatch_hole() {
    cube([
        display_board_width() + board_gap * 2,
        display_board_depth() + board_gap,
        display_board_height() + board_gap
    ]);
}

module swatch_container_slab() {
    cube([
        display_board_width() + board_gap * 4,
        board_gap + (display_board_depth() + board_gap * 2) * hold_count,
        display_board_height() + board_gap
    ]);
}

module swatch_container_slots() {
    union() {
        translate([board_gap * 4, board_gap, board_gap])
        cube([
            display_board_width() - board_gap * 4,
            (display_board_depth() + board_gap * 2) * hold_count - board_gap,
            display_board_height() + board_gap
        ]);
        
        for (i = [0:hold_count-1]) {
        echo((display_board_depth() + board_gap * 2) * i + board_gap);
            translate([
                board_gap,
                (display_board_depth() + board_gap * 2) * i + board_gap,
                board_gap
            ])
            swatch_hole();
        }
    }
}

module swatch_display_holes() {
    union() {
        for (y = [1:5]) {
            for (x = [1:4]) {
                translate([26.5 * x - 8, -1, y * 26 - 10])
                rotate([-90,0,0])
                cylinder(
                    h = (display_board_depth() + board_gap * 2) * hold_count + board_gap + 2,
                    d = 16
                );
            }
        }
    }

}

difference() {
    swatch_container_slab();
    swatch_container_slots();
    swatch_display_holes();
}
