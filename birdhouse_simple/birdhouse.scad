// Licensed under cc-by-sa-4.0, see
// LICENSE.txt file for details.

// As you'll likely be mounting this
// outdoors, you want to use a material
// resistant to UV and to weather.
// I used PETg. ASA is likely a very good
// choice. PLA may work in a pinch.
//
// For infill, I like about 20-25%
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
slope_angle = 10; // Slope forward
// The perch is optional
perch_outside_length = 40;
perch_inside_length = 30;

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
    screwHole(outer_diam=5, height=10, tolerance=screw_tolerance)
    cube([cube_dim*2,cube_dim*2,cube_dim], center=true);
    
    translate([cube_dim*2 + screw_diam, 0, 0])
    difference() {
        difference() {
            cube([cube_dim*2,cube_dim*2,cube_dim], center=true);
            translate([0,0,-cube_dim/2])
            screwHole(outer_diam=screw_diam, height=cube_dim, tolerance=screw_tolerance);
        }

        translate([0, 0, cube_dim/2-2])
        linear_extrude(2)
        circle(d = screw_diam*2);
    }
}

// The screwHole module in threads requires
// a child object but I'm often wanting to
// call without this object. This module
// makes it unnecessary.
module screwHole(outer_diam, height, position=[0,0,0], rotation=[0,0,0], pitch=0, tooth_angle=30, tolerance=0.4, tooth_height=0) {
  extra_height = 0.001 * height;

  difference() {
    if ($children) children();
    translate(position)
      rotate(rotation)
      translate([0, 0, -extra_height/2])
      ScrewThread(1.01*outer_diam + 1.25*tolerance, height + extra_height,
        pitch, tooth_angle, tolerance, tooth_height=tooth_height);
  }
}

module build_body(x, y, height) {
    translate([-wall_thickness, -wall_thickness, 0])
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
    screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);

    translate([floor_x*2/3, floor_y+wall_thickness/2, height-10])
    screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);

    translate([floor_x/2, -wall_thickness/2, height-10])
    screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
}

module build_screw_holes_body_for_floor(floor_x, floor_y) {
    translate([floor_x/2,floor_y/4,wall_thickness+1])
    rotate([180,0,180])
    union() {
        translate([40/2*1/3,40/2*1/3,0])
        screwHole(outer_diam=screw_diam, height=wall_thickness+1, tolerance=screw_tolerance);
    
        translate([-40/2*1/3,40/2*1/3,0])
        screwHole(outer_diam=screw_diam, height=wall_thickness+1, tolerance=screw_tolerance);
    
        translate([0,-40/2*1/3,0])
        screwHole(outer_diam=screw_diam, height=wall_thickness+1, tolerance=screw_tolerance);
    }
}

module build_birdhouse(floor_x, floor_y, height, entrance_hole_diameter, entrance_hole_height, perch) {
    difference() {
        build_body(floor_x, floor_y, height);

        build_entrance_hole(entrance_hole_diameter, floor_x, wall_thickness, entrance_hole_height);
        
        build_ventilation_holes_bottom(floor_x, floor_y);
        build_ventilation_holes_side(floor_y, entrance_hole_height + entrance_hole_diameter/2);
        
        build_screw_holes_body_for_roof(floor_x, floor_y, height);
        build_screw_holes_body_for_floor(floor_x, floor_y);
        
        if (perch) {
            translate([floor_x/2,-perch_outside_length-wall_thickness,entrance_hole_height-entrance_hole_diameter*1.5])
            rotate([270,90,0])
            scale([1.1,1,1])
            build_perch(outside_length=perch_outside_length,inside_length=perch_inside_length);
        }
    }
}

module build_screw_holes_for_roof(floor_x, floor_y) {
    
    translate([floor_x*1/3, floor_y+wall_thickness/2, 0])
    union() {
        screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([floor_x*2/3, floor_y+wall_thickness/2, 0])
    union() {
        screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([floor_x/2, -wall_thickness/2, 0])
    union() {
        screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
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
        screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([-40/2*1/3,40/2*1/3,0])
    union() {
        screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }

    translate([0,-40/2*1/3,0])
    union() {
        screwHole(outer_diam=screw_diam, height=wall_thickness, tolerance=screw_tolerance);
        translate([0,0,wall_thickness])
        cylinder(d = screw_diam*2, h=4, center=true);
    }
}

// From https://stackoverflow.com/questions/54115749/how-to-a-make-a-curved-sheet-cube-in-openscad
module curve(width, height, length, a) {
    if( a > 0 ) {
        r = (360 * (length/a)) / (2 * PI);
        translate( [-r-height/2,0,0] )
        rotate_extrude(angle = a)
        translate([r, 0, 0])
        square(size = [height, width], center = false);
    } else {
        translate( [-height/2,0,width] )
        rotate( a=270, v=[1,0,0] )
        linear_extrude( height = length )
        square(size = [height, width], center = false);

    }
}

module build_attachment(floor_y, slope_forward = 10) {
    rotate([0,90,0])
    union() {
        // base leg, attaches under the birdhouse
        difference() {
            translate([-20,-20,0])
            cube([40,floor_y+20,wall_thickness]);
            translate([0,0,wall_thickness])
            rotate([0,180,0])
            build_screw_holes_for_attachment();
        }
        
        // curve between base and wall legs
        translate([-20,floor_y,wall_thickness/2])
        rotate([0,90,0])
        curve(40, wall_thickness, 20, 90-slope_angle)
        cube([40,floor_y,wall_thickness]);

        // wall leg, for attaching to fence
    
        // This calculation was eyeballed.
        // I'd love an exact calculation
        translate([0,floor_y+12.6-0.235*slope_angle,0])
        rotate([270-slope_angle,0,0])
        translate([0,-floor_y,0])
        difference() {
            translate([-20,-20,0])
            cube([40,floor_y,wall_thickness]);
            translate([0,0,wall_thickness])
            rotate([180,0,0])
            build_screw_holes_for_attachment();
        }
    }
}

module build_perch(outside_length=40, inside_length=30, diameter=10) {
    length = outside_length + wall_thickness + inside_length;
    
    union() {
        cylinder(h=length,d=diameter);
        translate([0,0,outside_length])
        cylinder(h=10,d1=diameter,d2=diameter*2);
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
module Demo(perch = false) {
    union() {
        echo("Bird type:");
        echo(bird_type); // Set this at the top
    
        rotate([10,0,0])
        union() {
            translate([0,0,height])
            build_roof(floor_x, floor_y);
            build_birdhouse(floor_x, floor_y, height, entrance_hole_diameter, entrance_hole_height, perch=perch);
            
            if (perch) {
                translate([floor_x/2,-40-wall_thickness,entrance_hole_height-entrance_hole_diameter*1.5])
                rotate([270,90,0])
                build_perch(outside_length=perch_outside_length,inside_length=perch_inside_length);
            }

            translate([floor_x/2,floor_y/4,-wall_thickness])
            rotate([0,-90,0])
            build_attachment(floor_y);
        }
    }
}

// Test your printer's tolerances.
//build_screw_test();

Demo(perch=false);

// Or build each individual part. Uncomment
// the single part you wish.
//build_roof(floor_x, floor_y);
//build_birdhouse(floor_x, floor_y, height, entrance_hole_diameter, entrance_hole_height, perch=false);
//build_attachment(floor_y);
// Consider a brim here, though I didn't need one
// If you want one you can just glue to the outside,
// set inside_length=0 and ensure you call
// build_birdhouse with perch=false.
//build_perch(outside_length=perch_outside_length,inside_length=perch_inside_length);
