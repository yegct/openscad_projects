// Screw in to base... maybe M8?

// Libraries from https://openscad.org/libraries.html
use <smooth-prim/smooth_prim.scad>
use <threads-scad/threads.scad>

// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;
smooth_rad = 2;
tolerance = 0.8;

height = 4;
screw = 8; // Approximately an m8

// https://arstechnica.com/gaming/2018/09/thrustmaster-tpr-is-the-king-of-mass-market-flight-sim-pedals/
distance_between_base_screws = 333;

module screw_on_base(h) {
    union() {
        cylinder(d=20,h=h);
        translate([0,0,height])
        ScrewThread(outer_diam=screw,height=10,tolerance=tolerance);
    }
}

module arm_to_tpr() {
    union() {
        screw_on_base(h=height);
        cube([10,180,height]);
        translate([0,130,0])
        screw_on_base(h=height);
        translate([0,170,0])
        screw_on_base(h=height);
    }
}

module many_nuts(count = 6) {
    union() {
        for(i = [0 : count - 1]) {
            translate([i*30,-20,0])
            // TODO not sure about thickness
            MetricNut(diameter=screw,thickness=height*2,tolerance=tolerance);            
        }
    }
}

module tpr_base_legs() {
    union() {
        rotate([0,0,-45])
        arm_to_tpr();

        translate([distance_between_base_screws,0,0])
        rotate([0,0,45])
        arm_to_tpr();
    }
    many_nuts();
}

module brace(length) {
    difference() {
        union() {
            cube([10,length,height]);
            cylinder(d=20,h=height);
            translate([0,length,0])
            cylinder(d=20,h=height);
        }
        translate([0,0,-1])
        cylinder(d=screw*1.1,h=height+2);
        translate([0,length,-1])
        cylinder(d=screw*1.1,h=height+2);
    }
}

module Demo() {
    union() {
        tpr_base_legs();
        translate([212,118,height])
        rotate([0,0,90])
        brace(91);
        translate([240,90,height])
        rotate([0,0,90])
        brace(147);
    }
}

// 150, 90

Demo();

