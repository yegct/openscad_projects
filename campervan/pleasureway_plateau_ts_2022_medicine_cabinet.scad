// In mm
back_height = 40;
front_height = 32;
width_of_medicine_cabinet = 268;
width_spacer = width_of_medicine_cabinet / 2;
width_separator = width_of_medicine_cabinet / 4;
depth = 16;
separator_depth = 48;
thickness = 1;

module back_face(width) {
    cube([width, thickness, back_height]);
}

module hump(width) {
    difference() {
    cube([width, depth, front_height]);
    translate([-1,thickness,-thickness])
    cube([width + 2, depth - thickness * 2, front_height]);
    }
}

module separator() {
    cube([thickness, separator_depth, back_height]);
}

module print_spacer() {
    union() {
        hump(width_spacer/2);
        translate([0, depth - thickness, 0])
        back_face(width_spacer/2);
    }
}

module print_separator() {
    union() {
        hump(width_separator);
        translate([0, depth - thickness, 0])
        back_face(width_separator);
        translate([width_separator - thickness, depth, 0])
        separator();
    }
}

// For optimal positioning for printing, uncomment
// the rotate
rotate([0,90,0])
// Uncomment one of the following
//print_spacer();
print_separator();

