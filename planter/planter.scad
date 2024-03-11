// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;
splinesteps = $preview ? 8 : 32;

include <BOSL2/beziers.scad>
include <BOSL2/std.scad>
use <fontmetrics/fontmetrics.scad>
use <text_on/text_on.scad>

name_text = "Bob & Sylvia";
text_adjust = 2.8;
wall_thickness = 3;
mounting_height = 4;
text_size = 14;
font = "Arial";

texture = "diamonds";
tex_size=[5,5];

epsilon = 0.01;

bezpath = [
    [50, 0],
    [70, 20],
    [60, 60],
    [60, 110]
];

planter_max_radius = max([for(i = bezpath) i[0]]);
planter_height = max([for(i = bezpath) i[1]]);
planter_radius_at_top = bezpath[len(bezpath) - 1][0];

function equalateral_points() = [
    [-0.867, -0.5, 0.0],
    [0.867, -0.5, 0.0],
    [0.0, 1.0, 0.0]
];

module solid_base(path,r, h,depth) {
    difference() {
        hull()
        rotate_sweep(
            path,
            closed=true,
            style="concave"
        );
        
        translate([-r,-r,depth])
        cube([r*2,r*2,h-depth]);
    };
};

module planter() {
    path = bezpath_curve(bezpath, splinesteps=splinesteps);

    path_inside = bezpath_curve(
        [ for (i = bezpath) [i[0]-wall_thickness,i[1]] ],
        splinesteps=splinesteps
    );

    difference() {
        union() {
            // Outside skin with texture
            rotate_sweep(
                path, closed=true,
                texture=texture, tex_size=tex_size,
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
        solid_base(path, planter_max_radius, planter_height, mounting_height+wall_thickness);
    
        // mounting points
        for(equalateral_point = equalateral_points()*1.2)
        translate(equalateral_point * 25)
        cylinder(r = 4, h = mounting_height);
    
        // drainage holes
        rotate(180)
        for(equalateral_point = equalateral_points())
        translate(equalateral_point * 25)
        cylinder(r = 4, h = mounting_height+wall_thickness+epsilon);
        cylinder(r = 4, h = mounting_height+wall_thickness+epsilon);
    };
};

module bowl() {
    bowl_path = bezpath_curve(bezpath*1.4, splinesteps=splinesteps);
    
    inside_bowl_path = bezpath_curve(
        [ for (i = bezpath) [i[0]-wall_thickness,i[1]] ] * 1.4,
        splinesteps=splinesteps
    );

    difference() {
        union() {
            // Outside skin with texture
            rotate_sweep(
                bowl_path, closed=true,
                texture=texture, tex_size=tex_size,
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
        translate([-planter_max_radius*1.4,-planter_max_radius*1.4,30])
        cube([planter_max_radius*1.4*2,planter_max_radius*1.4*2,planter_height*1.4]);
    };
    solid_base(bowl_path,planter_max_radius*1.4,planter_height*1.4+1,wall_thickness);
    
    for(equalateral_point = equalateral_points()*1.2)
    translate([0,0,wall_thickness])
    translate(equalateral_point * 25)
    cylinder(r = 3, h = 4);
};

// The bottom doesn't sit flush with the
// build plate due to the texture.
// Clean that up.
module clean_up_bottom() {
    difference() {
        children();
        translate([-planter_max_radius*1.4,-planter_max_radius*1.4,-1])
        cube([planter_max_radius*1.4*2, planter_max_radius*1.4*2, 2]);
    };
};
        
module name_tag(text) {
    angle = measureText(text, font=font, size=text_size + text_adjust);
    rotate_extrude(angle=angle)
    translate([planter_radius_at_top,0,0])
    difference() {
        square([5,24]);
        translate([4,1,0])
        square([1,22]);
    };

    translate([planter_radius_at_top,0,0])
    cube([5,1,24]);

    rotate(angle-epsilon)
    translate([planter_radius_at_top,0,0])
    cube([5,1,24]);

    rotate(100)
    translate([0,0,3])
    text_on_cylinder(
        t=text,
        r1=planter_radius_at_top+5,
        r2=planter_radius_at_top+5,
        h=text_size/2,
        font=font,
        size=text_size);
}

clean_up_bottom()
planter();
translate([-1.2,-1.2,80])
name_tag(name_text);

clean_up_bottom()
bowl();
