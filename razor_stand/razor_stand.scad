// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

bowl_cutout_diameter = 88.0;
brush_cutout_diameter = 27.0;
razor_cutout_diameter = 12.0;

// Wall thickness
thickness = 1.6;
height = 150.0;
width = bowl_cutout_diameter + 20 + razor_cutout_diameter*3;
depth = bowl_cutout_diameter + 50.0;

// Smoothing is INCREDIBLY slow.
should_smooth = true;

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

module side_slice() {
    CubePoints = [
      [ -fudge, -fudge, thickness*2 ],
      [ thickness*2, -fudge, thickness*2 ],
      [ thickness*2, width/3, (height-thickness*4)/3 ],
      [ -fudge, width/3, (height-thickness*4)/3 ],
      [ -fudge, -fudge, height-thickness*2 ],
      [ thickness*2, -fudge, height-thickness*2 ],
      [ thickness*2, width/3, (height-thickness*4)*2/3 ],
      [ -fudge, width/3, (height-thickness*4)*2/3 ]];

    CubeFaces = [
      [0,1,2,3],
      [4,5,1,0],
      [7,6,5,4],
      [5,6,2,1],
      [6,7,3,2],
      [7,4,0,3]];

    polyhedron( CubePoints, CubeFaces );
}

module body() {
    difference() {
        cube([depth, width, height]);
        translate([thickness,-fudge,thickness*2])
        cube([depth,width+fudge*2,height-thickness*4]);
        translate([-fudge,-fudge,height-thickness])
        angle_slice();
        side_slice();
        translate([0,width,0])
        mirror([0,1,0])
        side_slice();
    }
}

module bowl_cutout() {
    translate([depth/2,(bowl_cutout_diameter+20)/2,thickness+fudge])
    cylinder(h=thickness+fudge, d = bowl_cutout_diameter);
}

module top_cutout(cutout_diameter) {
    translate([cutout_diameter/2,0,-thickness*2-fudge])
    union() {
        cylinder(h=thickness*2+fudge*2, d = cutout_diameter);
        translate([0,-cutout_diameter/2,0])
        cube([depth, cutout_diameter,thickness*2+fudge*2]);
    }
}

module stand() {
    difference() {
        body();
        bowl_cutout();
        
        // Brush cutout
        translate([depth/3,(bowl_cutout_diameter+20)/2+thickness*2,height])
        top_cutout(brush_cutout_diameter+thickness*2);

        // Razor cutout
        translate([depth/3,bowl_cutout_diameter+20+razor_cutout_diameter+thickness*2,height])
        top_cutout(razor_cutout_diameter+thickness*2);
    }
}

if (should_smooth) {
    minkowski() {
        stand();
        cylinder(r=thickness,h=1);
    }
} else {
    stand();
}
