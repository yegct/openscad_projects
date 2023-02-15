// Libraries from https://openscad.org/libraries.html
use <smooth-prim/smooth_prim.scad>

// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;
smooth_rad = 2;

// Dimensions of the table.
// Note that the actual table will be slightly larger
// to account for the rounding of the edges.
length = 150;
width = 50;
height = 50;
thickness = 10;

module build_outer() {
    SmoothCube([length,width,height], smooth_rad);
}

module build_inner() {
    translate([thickness,-1,-thickness])
    SmoothCube([length-thickness*2,width+2,height], smooth_rad);
}

module build_table() {
    difference() {
        build_outer();
        build_inner();
    }
}

module Demo() {
    build_table();
}

module Print() {
    // Rotate so it's best positioned for printing
    rotate([90,0,0])
    build_table();
}

Demo();
//Print();