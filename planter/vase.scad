// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;
splinesteps = $preview ? 8 : 32;

include <BOSL2/beziers.scad>
include <BOSL2/std.scad>

wall_thickness = 10;

texture = "checkers";
tex_size=[20,20];

vase_outer_width = 95 / 2;
vase_inner_width = vase_outer_width - wall_thickness;
vase_height = 220;
vase_scale = 0.80;
twist = 180;

module vase_body() {
    difference() {
        linear_sweep(
            hexagon(or=vase_outer_width),
            h=vase_height,
            scale=vase_scale,
            twist=twist,
            texture=texture,
            tex_depth=1,
            tex_size=tex_size,
            style="concave"
        );
    
        linear_sweep(
            hexagon(or=vase_inner_width),
            h=vase_height,
            scale=vase_scale,
            twist=twist
        );
    }
}

// base
module vase_base() {
    linear_sweep(
        hexagon(or=vase_outer_width),
        h=4,
        scale=vase_scale,
        twist=twist * 4 / vase_height
    );
}

module vase() {
    union() {
        vase_base();
        vase_body();
    }
}

vase();


