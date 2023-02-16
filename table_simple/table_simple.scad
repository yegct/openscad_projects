// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;

// Dimensions of the table.
// Note that the actual table will be slightly larger
// to account for the rounding of the edges.
length = 150;
width = 50;
height = 50;
thickness = 8;
smooth_rad = 2;

module build_outer() {
    difference() {
        minkowski() {
            cube([length,width,height]);
            sphere(smooth_rad);
        }
        translate([thickness,-smooth_rad,-thickness])
        cube([length-thickness*2,width+2*smooth_rad,height]);
    }
}

module build_v_support() {
    inner_height = height-thickness;

    CubePoints = [
      [ (length-thickness)/2, -smooth_rad, -smooth_rad ],  //0
      [ (length+thickness)/2, -smooth_rad, -smooth_rad ],  //1
      [ (length+thickness)/2, width+smooth_rad, -smooth_rad ],  //2
      [ (length-thickness)/2, width+smooth_rad, -smooth_rad ],  //3
      [ thickness, -smooth_rad, inner_height ],  //4
      [ length-thickness, -smooth_rad, inner_height ],  //5
      [ length-thickness, width+smooth_rad, inner_height ],  //6
      [ thickness, width+smooth_rad, inner_height ] ];  //7

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
    rotate([90,0,0])
    build_table(v_support);
}

Demo(v_support=true);
//Print(v_support=true);
