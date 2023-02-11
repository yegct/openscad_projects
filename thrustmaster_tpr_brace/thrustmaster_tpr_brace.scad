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
// TODO maybe *1.15?
nut = screw*1.1;
// TODO maybe a bit less?
// TODO what about other screw heights?
tpr_screw_height = 18;

// https://arstechnica.com/gaming/2018/09/thrustmaster-tpr-is-the-king-of-mass-market-flight-sim-pedals/
distance_between_base_screws = 333;

module screw_on_base(h,screw=screw) {
    union() {
        cylinder(d=20,h=h);
        translate([0,0,h])
        ScrewThread(outer_diam=screw,height=tpr_screw_height,tolerance=tolerance);
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

module many_nuts(count) {
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
        mirror([1,0,0])
        arm_to_tpr();
    }
}

module brace(length) {
    difference() {
        union() {
            cube([10,length,height]);

            cylinder(d=20,h=height);

            translate([0,length,0])
            cylinder(d=20,h=height);

            translate([0,length/2,0])
            screw_on_base(height);
        }
        translate([0,0,-1])
        cylinder(d=screw*1.1,h=height+2);
        translate([0,length,-1])
        cylinder(d=screw*1.1,h=height+2);
    }
}

module wall_base_connector(screw_distance) {
    difference() {
        cube([20,60,height]);
        translate([10,15,-1])
        cylinder(d=screw*1.1,h=height+2);
        translate([10,15+screw_distance,-1])
        cylinder(d=screw*1.1,h=height+2);
    }
}

module wall_extension() {
    CubePoints = [
      [  0,  0,  0 ],  //0
      [ 20,  0,  0 ],  //1
      [ 100, 90,  0 ],  //2
      [ -80, 90,  0 ],  //3
      [  0,  0,  height ],  //4
      [ 20,  0,  height ],  //5
      [ 100, 90,  height ],  //6
      [ -80, 90,  height ]]; //7
      
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
      
    polyhedron( CubePoints, CubeFaces );
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
module wall_curve() {
    translate([0,0,height/2])
    rotate([0,90,0])
    curve(180,height,40,90);
}

module wall_brace() {
    difference() {
        intersection() {
            cube([180,80,height]);
            translate([90,10,-1])
            linear_extrude(height+2)
            circle(d=180);
        }

        translate([40,50,-1])
        cylinder(d=screw*1.1,h=height+2);

        translate([140,50,-1])
        cylinder(d=screw*1.1,h=height+2);
        
        translate([90,20,-1])
        cylinder(d=screw*1.1,h=height+2);
    }
}

module wall(screw_distance) {
    union() {
        wall_base_connector(screw_distance);
        translate([0,60,0])
        wall_extension();
        translate([-80,150,0])
        wall_curve();
        translate([-80,179.5,height+25])
        rotate([90,0,0])
        wall_brace();
    }
}

module wall_block() {
    union() {
        difference() {
            cylinder(h=40,d=20);
            translate([0,0,10])
            cylinder(h=3,d=21);
        }
        translate([0,0,10])
        cylinder(h=3,d=18);

        translate([0,0,40])
        ScrewThread(outer_diam=screw,height=10,tolerance=tolerance);
    }
}

module wall_block_tpu_cover() {
    union() {
        difference() {
            cylinder(h=12,d=22.5);
            translate([0,0,2])
            cylinder(h=11,d=20.5);
        }

        translate([0,0,10])
        difference() {
            cylinder(h=2,d=22.5);
            translate([0,0,-1])
            cylinder(h=4,d=18.5);
        }
    }
}

module wall_block_with_cover() {
    union() {
        wall_block();
        wall_block_tpu_cover();
    }
}

module Demo() {
    tpr_base_legs();
    translate([212,118,height])
    rotate([0,0,90])
    brace(91);
    translate([240,90,height])
    rotate([0,0,90])
    brace(147);
    
    translate([156.5,75,height*2])
    wall(240-212);
    
    translate([117,295,87])
    rotate([90,0,0])
    wall_block_with_cover();

    translate([217,295,87])
    rotate([90,0,0])
    wall_block_with_cover();

    translate([167,295,57])
    rotate([90,0,0])
    wall_block_with_cover();
    
    many_nuts(12);
}

//Demo();

screw_on_base(h=4,screw=screw);
//translate([0,22,0])
//MetricNut(diameter=8.6,thickness=8,tolerance=tolerance);

//translate([22,0,0])
//MetricNut(diameter=8.8,thickness=8,tolerance=tolerance);

//translate([44,0,0])
//MetricNut(diameter=9.0,thickness=8,tolerance=tolerance);
