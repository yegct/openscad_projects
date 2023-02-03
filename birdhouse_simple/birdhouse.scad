// As you'll likely be mounting this
// outdoors, you want to use a material
// resistant to UV and to weather.
// ASA is likely your best choice,
// though PETg or even PLA may work.
//
// For infill, I like about 20% 
// cubic-subdivision.

// Libraries from https://openscad.org/libraries.html
use <smooth-prim/smooth_prim.scad>
use <threads-scad/threads.scad>

// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;

bird_type = "chickadee";
wall_thickness = 10;
ventilation_diameter = 2;
smooth_rad = 2;
screw_tolerance = 0.8;
screw_diam = 5; // M5 screw

// Based on information at http://www.earthdesign.ca/bime.html
// floor_x, floor_y, entrance_hole_diameter, entrance_hole_height
// Dimensions are in inches,
// floor measurements are internal.
dimensions = [
    ["chickadee", 4,4,1.125,5], // okay for Ender 3 S1
    ["finch", 6,6,2,7], // just fits for Ender 3 S1
    ["swallow", 7,7,2,15], // too large
    ["sparrow", 5.5,5.5,1.5,6.5]  // okay for Ender 3 S1
];

// Useful small print to see if your
// printer's tolerances will work.
// That is, will you be able to screw
// together the end result?
module build_screw_test(diam = 5) {
    cube_dim = screw_diam * 3;
    ScrewHole(outer_diam=5, height=10, tolerance=screw_tolerance)
    cube([cube_dim*2,cube_dim*2,cube_dim], center=true);
    
    translate([cube_dim*2 + screw_diam, 0, 0])
    difference() {
        difference() {
            cube([cube_dim*2,cube_dim*2,cube_dim], center=true);
            translate([0,0,-cube_dim/2])
            ScrewHoleWithoutChildren(outer_diam=screw_diam, height=cube_dim, tolerance=screw_tolerance);
        }

        translate([0, 0, cube_dim/2-2])
        linear_extrude(2)
        circle(d = screw_diam*2);
    }
}

// The ScrewHole module in threads requires
// a child object but I'm often wanting to
// call without this object. This module
// makes it unnecessary.
// The reason the arguments are increased
// before the call to ScrewThread is because
// the hole has to be large enough for the
// thread itself, not just the inner diameter
// of the screw.
module ScrewHoleWithoutChildren(outer_diam, height, pitch=0, tooth_angle=30, tolerance=0.4, tip_height=0, tooth_height=0, tip_min_fract=0) {
    ScrewThread(
        outer_diam=1.01*screw_diam+1.25*tolerance,
        height=height*1.001,
        pitch=pitch,
        tooth_angle=tooth_angle,
        tolerance=tolerance*1.25,
        tip_min_fract=0
    );
}

module build_body(x, y, height) {
    translate([-wall_thickness, -wall_thickness, 0])
    scale([1,1,1])
    difference() {
        SmoothCube([x+wall_thickness*2,y+wall_thickness*2,height], smooth_rad);
        translate([wall_thickness,wall_thickness,wall_thickness])
        SmoothCube([x,y,height+wall_thickness], smooth_rad);
    }
}

module build_entrance_hole(diameter, floor_x, wall_thickness, entrance_hole_height) {
    translate([floor_x/2,wall_thickness,entrance_hole_height])
    rotate([90,90,0])
    cylinder(h=wall_thickness*2, d=diameter);
}

module build_ventilation_holes_bottom(x, y) {
    union() {
        translate([x*1/4,wall_thickness,-1])
        cylinder(h=500, r=ventilation_diameter);

        translate([x*3/4,wall_thickness,-1])
        cylinder(h=500, r=ventilation_diameter);
    }
    
}

module build_ventilation_holes_side(y, height) {
    
    union() {
        translate([-wall_thickness-1,y*1/3,height])
        rotate([0,90,0])
        cylinder(h=500, r=ventilation_diameter);

        translate([-wall_thickness-1,y*2/3,height])
        rotate([0,90,0])
        cylinder(h=500, r=ventilation_diameter);
    }
}

module build_screw_holes_body_for_roof(floor_x, floor_y, height) {
    
    translate([floor_x*1/3, floor_y+wall_thickness/2, height-10])
    ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);

    translate([floor_x*2/3, floor_y+wall_thickness/2, height-10])
    ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);

    translate([floor_x/2, -wall_thickness/2, height-10])
    ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
}

module build_screw_holes_body_for_floor(floor_x, floor_y) {
    translate([floor_x/2,floor_y/4,wall_thickness+1])
    rotate([180,0,180])
    union() {
        translate([40/2*1/3,40/2*1/3,0])
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness+1, tolerance=screw_tolerance);
    
        translate([-40/2*1/3,40/2*1/3,0])
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness+1, tolerance=screw_tolerance);
    
        translate([0,-40/2*1/3,0])
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness+1, tolerance=screw_tolerance);
    }
}

module build_birdhouse(floor_x, floor_y, height, entrance_hole_diameter, entrance_hole_height) {
    difference() {
        build_body(floor_x, floor_y, height);

        build_entrance_hole(entrance_hole_diameter, floor_x, wall_thickness, entrance_hole_height);
        
        build_ventilation_holes_bottom(floor_x, floor_y);
        build_ventilation_holes_side(floor_y, entrance_hole_height + entrance_hole_diameter/2);
        
        build_screw_holes_body_for_roof(floor_x, floor_y, height);
        build_screw_holes_body_for_floor(floor_x, floor_y);
    }
}

module build_screw_holes_for_roof(floor_x, floor_y) {
    
    translate([floor_x*1/3, floor_y+wall_thickness/2, 0])
    union() {
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([floor_x*2/3, floor_y+wall_thickness/2, 0])
    union() {
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([floor_x/2, -wall_thickness/2, 0])
    union() {
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }
}

module build_roof(floor_x, floor_y) {
    difference() {
        translate([-20, -40, 0])
        // This provides some overhang
        SmoothCube([floor_x+20+wall_thickness*2,floor_y+40+wall_thickness*2,wall_thickness], smooth_rad);
    
        build_screw_holes_for_roof(floor_x, floor_y);
    }
}

module build_screw_holes_for_attachment() {
    translate([40/2*1/3,40/2*1/3,0])
    union() {
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([-40/2*1/3,40/2*1/3,0])
    union() {
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([0,-40/2*1/3,0])
    union() {
        ScrewHoleWithoutChildren(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }
}

module build_attachment(floor_y, slope_forward = 10) {
    union() {
        // base attachment circle
        translate([0,-floor_y/4,wall_thickness])
        rotate([0,180,0])
        difference() {
            cylinder(h=wall_thickness, d=40);
            build_screw_holes_for_attachment();
        }

        // Base leg
        translate([-10,15-floor_y/4,0])
        union() {
        
            cube([20,floor_y*3/4+wall_thickness,wall_thickness]);
        
        // Wall leg
            translate([0,floor_y*3/4+wall_thickness-10,5])
            rotate([-slope_forward,0,0])
            union() {
                cube([20,wall_thickness,100]);
                
                // wall attachment circle
                translate([10,10,115])
                rotate([90,0,0])
                difference() {
                    cylinder(h=wall_thickness, d=40);
                    build_screw_holes_for_attachment();
                }
            }
        }
    }
}

specifications = dimensions[search([bird_type], dimensions)[0]];
inches_to_mm = 25.4;
assert(specifications, "Failed to specify a known bird type");

floor_x = specifications[1] * inches_to_mm;
floor_y = specifications[2] * inches_to_mm;
entrance_hole_diameter = specifications[3] * inches_to_mm;
entrance_hole_height = specifications[4] * inches_to_mm;
height = (entrance_hole_height + entrance_hole_diameter/2) * 1.25;

// This displays the entire structure.
// If you want to print it, you'll
// want to render each part separately.
// Simply stick a ! at the beginning
// of each of the build_ calls.
// Start with the print test!
union() {
    echo("Bird type:");
    echo(bird_type); // Set this at the top

    // Test your printer's tolerances.
    //!build_screw_test();
    rotate([10,0,0])
    union() {
        translate([0,0,height])
        build_roof(floor_x, floor_y);
//        difference() {
        build_birdhouse(floor_x, floor_y, height, entrance_hole_diameter, entrance_hole_height);
//        translate([-50,-50,-5])
//            cube([1000,1000,height]);
//        }
        translate([floor_x/2,floor_y/2,-wall_thickness])
        build_attachment(floor_y);
    }
}

// TODO: Consider cubes instead of cylinders for attachment points?
