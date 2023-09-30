// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

// Wall thickness
thickness = 5.0;
height = 200.0;
width = 150.0;
depth = 150.0;
bowl_diameter = 85.0;
brush_cutout_diameter = 40.0;
razor_cutout_diameter = 20.0;
// Smoothing is INCREDIBLY slow.
should_smooth = false;

fudge = 0.01;

module angle_slice() {
        CubePoints = [
          [ 0, 0, 0 ],
          [ depth+fudge*2, 0, thickness+fudge ],
          [ depth+fudge*2, width+fudge*2, thickness+fudge ],
          [ 0, width+fudge*2, 0 ],
          [ 0, 0, thickness+fudge*2 ],
          [ depth+fudge*2, 0, thickness+fudge ],
          [ depth+fudge*2, width+fudge*2, thickness+fudge ],
          [ 0, width+fudge*2, thickness+fudge ]];

        CubeFaces = [
          [0,1,2,3],
          [4,5,1,0],
          [7,6,5,4],
          [5,6,2,1],
          [6,7,3,2],
          [7,4,0,3]];

        polyhedron( CubePoints, CubeFaces );
}

module stand() {
    difference() {
        cube([depth, width, height]);
        translate([fudge,thickness,thickness*2])
        cube([depth+fudge,width-thickness*2,height-thickness*4]);
        translate([-fudge,-fudge,height-thickness])
        angle_slice();
    }
}

module bowl_cutout() {
    translate([depth/2,width/2,thickness+fudge])
    cylinder(h=thickness+fudge, d = bowl_diameter);
}

module top_cutout(cutout_diameter) {
    translate([cutout_diameter/2,0,-thickness])
    union() {
        cylinder(h=thickness*2+fudge*2, d = cutout_diameter);
        translate([0,-cutout_diameter/2,0])
        cube([depth, cutout_diameter,thickness*2+fudge*2]);
    }
}

module unsmoothed_object() {
    difference() {
        stand();
        translate([depth/3,width/3,height-thickness-fudge])
        top_cutout(brush_cutout_diameter);
        translate([depth/3,width*2/3,height-thickness-fudge])
        top_cutout(razor_cutout_diameter);
        bowl_cutout();
    }
}

if (should_smooth) {
    minkowski() {
        unsmoothed_object();
        cylinder(d=5,h=1);
    }
} else {
    unsmoothed_object();
}
