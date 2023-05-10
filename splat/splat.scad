// Smoothness of generated output
nozzle_diameter = 0.4;
$fs = nozzle_diameter / 2;
$fa = 5;

large_circle_r = 40;
small_circle_r = 16;
point_r = 5;
thickness = 1.9;

linear_extrude(thickness)
difference() {
    union() {
        circle(r = large_circle_r);
        round_points();
    }
    cutouts();
}

module cutouts() {
    union() {
        for (z = [0:60:300]) {
            rotate([0,0,z])
            translate([large_circle_r,0,0])
            circle(r=small_circle_r);
        }
    }
}

module round_points() {
    union() {
        for (z = [30:60:330]) {
            rotate([0,0,z])
            translate([large_circle_r - point_r / 3,0,0])
            circle(r=point_r);
        }
    }
    
}