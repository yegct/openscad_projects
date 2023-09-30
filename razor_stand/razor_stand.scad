// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;

// Wall thickness
thickness = 10.0;
height = 250.0;
width = 200.0;
depth = 150.0;
bowl_diameter = 50.0;
brush_cutout_diameter = 40.0;
razor_cutout_diameter = 20.0;

smooth_rad = 5;
fudge = 0.01;

// Libraries from https://openscad.org/libraries.html
use <smooth-prim/smooth_prim.scad>

module stand() {
    difference() {
        SmoothCube([depth, width, height], 5);
        translate([0,thickness,thickness*2])
        cube([depth,width-thickness*2,height-thickness*3]);
    }
}

module bowl_cutout() {
    translate([depth/2,width/2,thickness+fudge])
    cylinder(h=thickness, d = bowl_diameter);
}

module top_cutout(cutout_diameter) {
    translate([cutout_diameter/2,0,0])
    union() {
        translate([0,0,-fudge])
        cylinder(h=thickness+fudge*2, d = cutout_diameter);
        translate([0,-cutout_diameter/2,-fudge])
        cube([depth, cutout_diameter,thickness+fudge*2]);
    }
}

module razor_cutout() {
    translate([depth/2,width*2/3,height-thickness-fudge])
    union() {
        translate([0,0,-fudge])
        cylinder(h=thickness+fudge*2, d = bowl_diameter);
        translate([0,-bowl_diameter/2,-fudge])
        cube([depth, bowl_diameter,thickness+fudge*2]);
    }
}

difference() {
    stand();
    bowl_cutout();
    translate([depth/3,width/3,height-thickness-fudge])
    top_cutout(brush_cutout_diameter);
    translate([depth/3,width*2/3,height-thickness-fudge])
    top_cutout(razor_cutout_diameter);
}




// todo bend top up a bit