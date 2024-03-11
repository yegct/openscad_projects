// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;
splinesteps = $preview ? 8 : 32;

include <BOSL2/std.scad>
use <text_on/text_on.scad>

name_text = "Name";
param_wall_thickness = 2;
param_height = 180;
param_width = 100;
text_colour = "white";
text_size = 20;
twist = 120;
epsilon = 0.01;

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
path = bezpath_curve(bezpath, splinesteps=splinesteps);

bezpath_inside = [
    [44, 0],
    [64, 20],
    [54, 60],
    [54, 110]
];
path_inside = bezpath_curve(bezpath_inside, splinesteps=splinesteps);

// Solid base
module solid_base(path,r, h) {
    difference() {
        hull()
        rotate_sweep(
            path,
            closed=true,
            style="concave"
        );
        
        translate([-r,-r,8])
        cube([r*2,r*2,h-8]);
    };
};

equalateral_points = [
    [-0.866, -0.5, 0.0],
    [0.866, -0.5, 0.0],
    [0.0, 1.0, 0.0]
];

module planter() {

    difference() {
        union() {
            // Outside skin with texture
            rotate_sweep(
                path, closed=true,
                texture="diamonds", tex_size=[5,5],
                tex_depth=1, style="concave");
            
            // Solid object without texture
            hull()
            rotate_sweep(
                path,
                closed=true,
                style="concave"
            );
        };
        
        // Carve out inside
        hull()
        rotate_sweep(
            path_inside,
            closed=false,
            style="concave");
    
    };
    
    difference() {
        solid_base(path, 70, 110);
    
        // mounting points
        for(equalateral_point = equalateral_points)
        translate(equalateral_point * 25)
        cylinder(r = 4, h = 4);
    
        // drainage holes
        rotate(180)
        for(equalateral_point = equalateral_points)
        translate(equalateral_point * 25)
        cylinder(r = 4, h = 8);
        cylinder(r = 4, h = 8);
    };
};

// Bowl
bowl_path_points = [
    [50, 0],
    [70, 20],
    [60, 60],
    [60, 110]
];
bowl_path = bezpath_curve(bowl_path_points*1.4, splinesteps=splinesteps);

bowl_inside_path_points = [
    [44, 0],
    [64, 20],
    [54, 60],
    [54, 110]
];
inside_bowl_path = bezpath_curve(bowl_inside_path_points*1.4, splinesteps=splinesteps);

module bowl() {
    difference() {
        union() {
            // Outside skin with texture
            rotate_sweep(
                bowl_path, closed=true,
                texture="diamonds", tex_size=[5,5],
                tex_depth=1, style="concave");
            
            // Solid object without texture
            hull()
            rotate_sweep(
                bowl_path,
                closed=true,
                style="concave"
            );
        };
        
        // Carve out inside
        hull()
        rotate_sweep(
            inside_bowl_path,
            closed=false,
            style="concave");
        
        // Carve out the whole top section
        translate([-70*1.4,-70*1.4,20])
        cube([70*1.4*2,70*1.4*2,110*1.4]);
    };
    solid_base(bowl_path,70*1.4,110*1.4+1);
    
    for(equalateral_point = equalateral_points)
    translate([0,0,8])
    translate(equalateral_point * 25)
    cylinder(r = 3, h = 4);
};

// The bottom doesn't sit flush with the
// build plate due to the texture.
// Clean that up.
module clean_up_bottom() {
    difference() {
        children();
        translate([-60*1.4,-60*1.4,-1])
        cube([60*1.4*2, 60*1.4*2, 2]);
    };
};
        
module name_tag(angle=60, text) {
    rotate_extrude(angle=angle)
    translate([60,0,0])
    difference() {
        square([5,24]);
        translate([4,1,0])
        square([1,22]);
    };

    translate([60,0,0])
    cube([5,1,24]);

    rotate(angle-epsilon)
    translate([60,0,0])
    cube([5,1,24]);

    rotate(100)
    translate([0,0,-3])
    text_on_cylinder(
        t=text,
        r1=65,
        r2=65,
        h=text_size/2,
        font="Arial:style=Bold",
        direction="ttb",
        size=text_size);
}

//clean_up_bottom()
//planter();
//translate([-1.2,-1.2,80])
//name_tag(104, "Christa");

clean_up_bottom()
bowl();



//TODO
// 1. Thinner walls
// 2. Change hole pattern?
// 3. Figure out how to center the text?
// 4. Epsilon optimize
// 5. Restructure code
