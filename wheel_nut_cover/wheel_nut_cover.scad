// Licensed under the terms of CC BY-SA 4.0 DEED
// Attribution-ShareAlike 4.0 International.
// For full licensing terms, see
// https://creativecommons.org/licenses/by-sa/4.0/deed.en
// Source code at https://github.com/yegct/openscad_projects/tree/main/wheel_nut_cover


// For smoothing purposes
$fs = $preview ? $fs : 0.2;
$fa = $preview ? $fa : 5;

// What to print
object = "cover"; // [cover, puller]
// Typically 17 or 19 or 21
nut_size = 19;
height = 16;
cover_thickness = 1.25;
puller_thickness = 4;

// Fix OpenSCAD preview rendering problem
function epsilon() = 0.01;

// We use a circle approximated with six sides,
// i.e. a regular hexagon.
// Our nut size is the short diagonal of this hexagon
// but we need to use the long diagonal as the
// circle's diameter.
function long_diagonal(short_diagonal) =
    short_diagonal * 2 / sqrt(3);

// Add a bit of wiggle room.    
outer_diam = long_diagonal(short_diagonal = nut_size) * 1.01;

module hexagon(r = 0, d = 0) {
    if (r == 0) {
        circle(d = d, $fn = 6);
    } else {
        circle(r = r, $fn = 6);
    }
}

module cover_grip() {
    difference() {
        cylinder(h = 2.5, d = outer_diam + cover_thickness * 2 + epsilon());
        cylinder(h = 2.5, d = outer_diam + cover_thickness);
    }
}

module nut_cover() {
    difference() {
        // outside
        cylinder(h = height, d = outer_diam + cover_thickness * 2);

        // inside
        translate([0, 0, -epsilon()])
        linear_extrude(height - cover_thickness)
        hexagon(d = outer_diam);
    
        translate([0, 0, height - 2.5 * 3])
        cover_grip();
    }
}

module puller_curved_bit(puller_diam) {
    difference() {
        circle(d = puller_diam);
        circle(d = puller_diam - puller_thickness);
        translate([0, puller_diam / 2, 0])
        square([puller_diam, puller_diam], center = true);
    }
}

module puller_long_arms(puller_diam) {
    translate([0, puller_diam, 0])
    difference() {
        square([puller_diam, puller_diam * 2], center = true);
        square([puller_diam - puller_thickness, puller_diam * 2 + epsilon()], center = true);
    }
}

module puller_crossbar(puller_diam) {
    translate([0, puller_diam * 1, 0])
    square([puller_diam, 1.5], center = true);
}

// Two quarter-circles to grab on to the cover notch
module puller_end_catches(puller_diam) {
    translate([-puller_diam/2, puller_diam * 2, 0])
    rotate_extrude(angle = 90)
    square([puller_thickness, 10]);

    translate([puller_diam/2, puller_diam * 2, 0])
    rotate([0, 0, 90])
    rotate_extrude(angle = 90)
    square([puller_thickness, 10]);
}

module puller() {
    puller_diam = outer_diam * 1.2;
    
    linear_extrude(10) {
        puller_curved_bit(puller_diam);
        puller_long_arms(puller_diam);
        puller_crossbar(puller_diam);
    }
    puller_end_catches(puller_diam);
}

if (object == "cover")
    nut_cover();
else
    puller();
