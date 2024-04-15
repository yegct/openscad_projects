// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = $preview ? $fs : nozzle_diameter / 2;
$fa = $preview ? $fa : 5;

include <BOSL2/std.scad>
use <text_on/text_on.scad>

module heart_sub_component(radius) {
    rotated_angle = 45;
    diameter = radius * 2;
    $fn = 48;

    translate([-radius * cos(rotated_angle), 0, 0]) 
        rotate(-rotated_angle) union() {
            circle(radius);
            translate([0, -radius, 0]) 
                square(diameter);
        }
}

module heart(radius, center = false) {
    offsetX = center ? 0 : radius + radius * cos(45);
    offsetY = center ? 1.5 * radius * sin(45) - 0.5 * radius : 3 * radius * sin(45);

    //translate([offsetX, offsetY, 0])
    union() {
        heart_sub_component(radius);
        mirror([1, 0, 0]) heart_sub_component(radius);
    }

}

//linear_extrude(height=100,twist=90,slices=100)
//translate([0,0,-100])
//linear_extrude(height=100,slices=100)
//heart(40);

tex = texture("diamonds");

difference() {
    linear_sweep(
        circle(r=25),
        texture=tex,
        h=150,
        tex_size=[10,10], style="concave"
    );

    translate([0,0,5])
    cylinder(r = 22.5, h=150);
    
}


chars = "Christopher";

rad1=25;
rad2=25;
//cylinder(r1=rad1,r2=rad2,h=40); //Partially visible "base" object
translate([0,0,75])
text_on_cylinder(t=chars,r1=rad1,r2=rad2,h=40, font="Arial:style=Bold", direction="ttb", size=10);