// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

include <BOSL2/std.scad>

name_text = "Name";
param_wall_thickness = 2;
param_height = 150;
param_width = 40;
param_base_height = 30;
text_colour = "white";
epsilon = 0.1;

module vase_base() {
    // diagonal
    CubePoints = [
      [ 0, 0, 0 ],  //0
      [ param_width/2, 0, 0 ],  //1
      [ param_width/2, param_width, 0 ],  //2
      [ 0, param_width, 0 ],  //3
      [ 0, 0, param_base_height ],  //4
      [ 0, 0, param_base_height ],  //5
      [ 0, param_width, param_base_height ],  //6
      [ 0, param_width, param_base_height ]]; //7
      
    CubeFaces = [
      [0,1,2,3],  // bottom
      [4,5,1,0],  // front
      [7,6,5,4],  // top
      [5,6,2,1],  // right
      [6,7,3,2],  // back
      [7,4,0,3]]; // left
      
    polyhedron( CubePoints, CubeFaces );
    
    // Calculate the angles and length
    // of the polyhedron
    b = param_base_height;
    c = param_width / 2;
    angle_a = 90;
    a = sqrt(b*b + c*c - 2*b*c*cos(angle_a));
    angle_b = acos((a*a+c*c-b*b)/(2*a*c));

    translate([param_width/2, param_width/2, 0])
    rotate([angle_b,0,90])
    translate([0,a/2,-epsilon])
    vase_text();
}

module vase_text() {
    color(text_colour)
    linear_extrude(height=1)
    text(
        text = name_text,
        font="Arial:style=Bold",
        halign = "center",
        valign = "center",
        size = 10
    );
}

module vase_body() {
    difference() {
        linear_sweep(
            square(param_width),
            texture=texture("diamonds"),
            h=param_height,
            tex_size=[10,10], style="concave"
        );
        translate([
            param_wall_thickness,
            param_wall_thickness,
            param_wall_thickness
        ]) cube([
            param_width - param_wall_thickness * 2,
            param_width - param_wall_thickness * 2,
            param_height
        ]);
    };
}

module vase() {
    translate([param_width, 0, 0])
    vase_base();
    vase_body();
}

vase();
