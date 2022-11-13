include <rounded_polygon.scad>;
$fn=50;
thickness = 4;
switch_size = 15.4;

rand = 2;

battery_connector_height = 5;

battery_length = 27;
battery_width = 20;
battery_height = 4;

screw_diameter = 2;

corners = [
    [103 + 2.5*rand, 0 - rand, rand], 
    [116 + 2.5*rand, 73 + rand, rand], 
    [22 + rand,90 + rand, rand], 
    [0, 90 + rand, 0], 
    [0,0 - rand, 0]];

pcb_width = 19;
pcb_length = 34;
pcb_height = 3.5;

diode_positions = [
    [85.994, 3.4      , -280],
    [87.645, 13.433   , -280],
    [91.328,    33.372, -280],
    [93.995,    50.898, -280],
    [66.69,     3.781 , -280],
    [68.468,    13.433, -280],
    [71.516,    31.848, -280],
    [75.072,    51.279, -280],
    [46.37,     3.908 , -270],
    [49.545,    15.719, -280],
    [52.466,    33.499, -280],
    [55.895,    53.184, -280],
    [39.258,    3.908 , -270],
    [32.4,      28.927, -280],
    [35.194,    44.675, -280],
    [37.988,    61.566, -280],
    [21.351,    4.289 , -270],
    [12.461,    31.467, -280],
    [16.779,    50.136, -270],
    [19.827,    66.646, -280],
    [11.445,    50.136, -270],
    [-3.922,    66.011, -270],
    [-21.575,	14.576, -270],
    [-13.955,	36.293, -270],
    [-15.987,	50.009, -270],
    [-20.432,	67.027, -260],
    [-39.355,	3.4   , -270],
    [-32.751,	29.816, -270],
    [-36.434,	48.104, -260],
    [-39.482,	66.265, -260],
    [-47.356,	3.4   , -270],
    [-50.658,	20.672, -260],
    [-53.96	,   39.722, -260],
    [-56.627,	52.549, -260],
    [-66.914,	3.4   , -260],
    [-68.565,	12.163, -260],
    [-72.375,	34.007, -260],
    [-75.55	,   49.628, -260],
    [-86.218,	3.4   , -260],
    [-88.123,	13.814, -260],
    [-91.965,	34.107, -260],
    [-94.854,	50.898, -260]
];

switch_positions = [
    [ 96.677838, 9.177777],
    [99.977153, 27.889125],
    [103.276469, 46.600472],
    [106.575784, 65.311819],
    [77.445546,	9.52267],
    [80.744862,	28.234017],
    [84.044177,	46.945364],
    [87.343492,	65.656711],
    [57.865958,	7.897946],
    [61.165273,	26.609293],
    [64.464589,	45.320641],
    [67.763904,	64.031988],
    [40.1965, 17.106108],
    [43.495815,	35.817455],
    [46.795131,	54.528803],
    [50.094446,	73.24015],
    [22.353393,	25.329462],
    [25.652709,	44.040809],
    [28.952024,	62.752157],
    [32.25134, 81.463504],
    [11.977159,	75.89955]];

offsets = [5.5/cos(10), sqrt(2)*5.5/sin(10)];



pump_positions = [
    [16, 60.18, 3],
    [0, 63, 0],
    [0, 0 - rand, 0],
    [50 - offsets[0], 0 - rand, 0],
    [50- offsets[0], 5, 3],
    [22.353393 - 12, 25.329462 - 10, 3]

];

screw_position = [
    [70, 76],
    [34, 5],
    [16, 58],
    [0, 84],
    [106, 5],
    [117, 65]];

module diode_cutout(positions){
    for (position = positions)
    {
        translate([position[0], position[1], 0.75])
            rotate([0, 0, position[2]])
                cube([4.2, 2.2, 1.5], center=true);
    }
}

module pcb_cutout(){
    translate([0,pcb_length/2 - 17.878, battery_connector_height/2])
    cube([pcb_width, pcb_length, battery_connector_height], center= true);
    translate([0, -pcb_length/2, pcb_height/2])
    cube([9, 20, pcb_height], center=true);
}

module battery_connector_cutout(){ 
    rotate([0, 0, 90])
    translate([2,0,0])
    cube([8, 30, battery_connector_height]);
    translate([-4, 2,0])
    cube([8,50,battery_connector_height]);
}

module copy_mirror(vec){
    children();
    mirror(vec) children();
}

module switch_holes(positions){
    for (position = positions)
    {
        translate([position[0], position[1], 0])
            rotate([0, 0, -10])
            cube(switch_size, center= true);
    }
}

module screw_holes(positions){
    for (position = positions)
    {
        translate([position[0], position[1], -thickness/2])
            cylinder(thickness +1.5, r=screw_diameter/2);
    }
}

module battery_cutout(){
    translate([-battery_width/2, pcb_length - 0.1, 0])
    {
        cube([battery_width, battery_length, battery_height]);
        cube([battery_width, battery_length - 3, battery_connector_height]);
    }
}



difference(){
    union(){
        copy_mirror([1,0,0])
            linear_extrude(thickness)
                polygon(polyRound(corners, 50));
        copy_mirror([1,0,0])
            linear_extrude(6.6)
                polygon(polyRound(pump_positions, 50));
    }
    battery_cutout();
    copy_mirror([1, 0, 0])
        switch_holes(switch_positions);
    copy_mirror([1, 0, 0])
        #screw_holes(screw_position);
    translate([0, 17.878, 0])
        pcb_cutout();
    translate([0, -2, 0])
    battery_connector_cutout();
    diode_cutout(diode_positions);
}