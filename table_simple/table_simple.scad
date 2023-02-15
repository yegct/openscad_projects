// Libraries from https://openscad.org/libraries.html
use <smooth-prim/smooth_prim.scad>

// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;
smooth_rad = 2;

// Dimensions of the table.
// Note that the actual table will be slightly larger
// to account for the rounding of the edges.
length = 100;
width = 100;
height = 50;
thickness = 8;

module build_outer() {
    SmoothCube([length,width,height], smooth_rad);
}

module build_inner() {
    translate([thickness,-1,-thickness])
    SmoothCube([length-thickness*2,width+2,height], smooth_rad);
}

module build_m_leg() {
    inner_height = height-thickness;

    CubePoints = [
      [ (length-thickness)/2, 0, 0 ],  //0
      [ (length+thickness)/2, 0, 0 ],  //1
      [ (length+thickness)/2, width, 0 ],  //2
      [ (length-thickness)/2, width, 0 ],  //3
      [ thickness, 0, inner_height ],  //4
      [ length-smooth_rad, 0, inner_height ],  //5
      [ length-smooth_rad, width, inner_height ],  //6
      [ thickness, width, inner_height ] ];  //7

    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left

    polyhedron( CubePoints, CubeFaces );
}

module build_table(m_support) {
    union() {
        difference() {
            build_outer();
            build_inner();
        }
        if (m_support) {
            difference() {
                build_m_leg();
                translate([0,-1,thickness])
                scale([1,1.1,1])
                build_m_leg();
            }
        }
    }
}

module Demo(m_support) {
    build_table(m_support);
}

module Print(m_support) {
    // Rotate so it's best positioned for printing
    rotate([90,0,0])
    build_table(m_support);
}

Demo(m_support=true);
//Print(m_support=true);
