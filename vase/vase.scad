// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

include <BOSL2/std.scad>
use <text_on/text_on.scad>

name_text = "Name";
param_wall_thickness = 2;
param_height = 180;
param_width = 100;
text_colour = "white";
text_size = 20;
twist = 120;
epsilon = 0.1;

module vase_text() {
    color(text_colour)
    text_on_cylinder(
        t=name_text,
        r1=param_width/2,
        r2=param_width/2,
        h=text_size/2,
        font="Arial:style=Bold",
        direction="ttb",
        size=text_size);
}

module vase_body() {
    color("blue")
    difference() {
        linear_sweep(
            circle(d = param_width),
            h = param_height,
            texture=texture("diamonds"),
            tex_size=[10,10],
            style="concave",
            twist=twist
        );
        translate([0, 0, param_wall_thickness])
            cylinder(h = param_height, d = param_width - 2 * param_wall_thickness);
    };
}

module vase() {
    vase_body();
    vase_text();
}

vase();
