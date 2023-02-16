// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;

// Dimensions of the table.
// These dimensions include the rounding factor.
smooth_rad = 2;
length = 150;
width = 100;
height = 50;
thickness = 8;

l = length - smooth_rad*2;
w = width - smooth_rad*2;
h = height - smooth_rad*2;

module build_outer() {
    difference() {
        minkowski() {
            cube([l,w,h]);
            sphere(smooth_rad);
        }
        translate([thickness,-smooth_rad,-thickness])
        cube([l-thickness*2,w+2*smooth_rad,h]);
    }
}

module build_v_support() {
    CubePoints = [
      [ (l-thickness)/2, -smooth_rad, -smooth_rad ],  //0
      [ (l+thickness)/2, -smooth_rad, -smooth_rad ],  //1
      [ (l+thickness)/2, w+smooth_rad, -smooth_rad ],  //2
      [ (l-thickness)/2, w+smooth_rad, -smooth_rad ],  //3
      [ thickness, -smooth_rad, h-thickness ],  //4
      [ l-thickness, -smooth_rad, h-thickness ],  //5
      [ l-thickness, w+smooth_rad, h-thickness ],  //6
      [ thickness, w+smooth_rad, h-thickness ] ];  //7

    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left

    polyhedron( CubePoints, CubeFaces );
}

module build_table(v_support) {
    translate([smooth_rad,smooth_rad,smooth_rad])
    union() {
        build_outer();
        if (v_support) {
            difference() {
                build_v_support();
                translate([0,-1,thickness])
                scale([1,1.1,1])
                build_v_support();
            }
        }
    }
}

module Demo(v_support) {
    build_table(v_support);
}

module Print(v_support) {
    // Rotate so it's best positioned for printing
    if (v_support) {
        translate([0,height,0])
        rotate([90,0,0])
        build_table(v_support);
    } else {
        translate([0,width,height])
        rotate([180,0,0])
        build_table(v_support);
    }
}

Demo(v_support=true);
//Print(v_support=true);
