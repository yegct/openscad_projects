// Oriented for 3d printer
print_orientation = false;
// divide up the horizontal space
include_separator = false;

// mm
back_height = 40;
// mm
front_height = 32;
// mm
width_of_medicine_cabinet = 268;
// mm
depth = 16;
// mm
separator_depth = 48;
// mm
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

module build_object() {
    width_separator = width_of_medicine_cabinet / 4;
    union() {
        hump(width_separator);
        translate([0, depth - thickness, 0])
        back_face(width_separator);
        if (include_separator) {
            translate([width_separator - thickness, depth, 0])
            separator();
        }
    }
}

if (print_orientation) {
    rotate([0,90,0])
    build_object();
} else {
    build_object();
}
