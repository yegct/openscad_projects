//rotate([90,0,0])
//translate([-74,-61,-4])
//import("./color_card_board_n1_10_gap15.stl");

display_board_width = 108;
display_board_height = 135;
display_board_depth = 3;
board_gap = 2;

hold_count = 3;



module swatch_hole() {
    cube([
        display_board_width + board_gap * 2,
        display_board_depth + board_gap,
        display_board_height + board_gap
    ]);
}

module swatch_container_slab() {
    cube([
        display_board_width + board_gap * 4,
        board_gap + (display_board_depth + board_gap * 2) * hold_count,
        display_board_height + board_gap
    ]);
}

module swatch_container_slots() {
    difference() {
        swatch_container_slab();

        translate([board_gap * 4, board_gap, board_gap])
        cube([
            display_board_width - board_gap * 4,
            (display_board_depth + board_gap * 2) * hold_count - board_gap,
            display_board_height + board_gap
        ]);
        
        for (i = [0:hold_count-1]) {
        echo((display_board_depth + board_gap * 2) * i + board_gap);
            translate([
                board_gap,
                (display_board_depth + board_gap * 2) * i + board_gap,
                board_gap
            ])
            swatch_hole();
        }
    }
}

swatch_container_slots();
