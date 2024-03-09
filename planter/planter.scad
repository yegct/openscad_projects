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

// vase();

include <BOSL2/beziers.scad>
bezpath_vase = [
    [10, 0],
    [30, 10],
    [20, 60],
    [10, 110]
];
bezpath_planter = [
    [50, 0],
    [70, 20],
    [60, 60],
    [60, 110]
];
bezpath = bezpath_planter;
path = bezpath_curve(bezpath, splinesteps=32);

bezpath_inside = [
    [44, 0],
    [64, 20],
    [54, 60],
    [54, 110]
];
path_inside = bezpath_curve(bezpath_inside, splinesteps=32);

//difference() {
//    union() {
//        // Outside skin with texture
//        rotate_sweep(
//            path, closed=true,
//            texture="diamonds", tex_size=[10,10],
//            tex_depth=1, style="concave");
//        
//        // Solid object without texture
//        hull()
//        rotate_sweep(
//            path,
//            closed=true,
//            style="concave"
//        );
//    };
//    
//    // Carve out inside
//    hull()
//    rotate_sweep(
//        path_inside,
//        closed=false,
//        style="concave");
//
//};
//
//// Solid base
//
module solid_base() {
    difference() {
        hull()
        rotate_sweep(
            path,
            closed=true,
            style="concave"
        );
        
        translate([0,0,8])
        cylinder(r=70,h=110-8);
    };
};

equalateral_points = [
    [-0.866, -0.5, 0.0],
    [0.866, -0.5, 0.0],
    [0.0, 1.0, 0.0]
];
//difference() {
//    solid_base();
//
//    for(equalateral_point = equalateral_points)
//    translate(equalateral_point * 20)
//    cylinder(r = 4, h = 4);
//};


cylinder(r = 70, h=1);

for(equalateral_point = equalateral_points)
translate(equalateral_point * 20)
cylinder(r = 3, h = 4);
