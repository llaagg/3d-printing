// import the miscellaneous boards library
use <misc_boards.scad>;

// call the Raspberry Pi module from the misc_boards library

//raspberrypi_3_model_b_holes();

le_maker_w = 92;
le_maker_k = 60;

module hole()
{
    radi = 2.75/2;
    linear_extrude(1.6)
     circle(r=radi, $fn=16);
    
}



module lepotato()
{
    
    color("gray")
    translate([ 20, -5 + le_maker_w,2])
        cube([20,10,18]);
    
    color("green")
    difference()
    {
        hole_r2 = 2.75/2;
        cube([le_maker_k, le_maker_w, 1.5]);
        
        translate([ 3.5, 3.5,0])
            hole();
        translate([ 49+3.5, 3.5,0])
            hole();
        
        translate([ 3.5, le_maker_w-3.5,0])
            hole();
        translate([ le_maker_k-3.5, le_maker_w-3.5,0])
            hole();
    }
}

module support()
{
    cube([10,30,1.5]);
    
    translate([5,15,0])
        linear_extrude(25)
        circle(d=5);
}


module supporters_potato()
{
    translate([-10,10,0])
        support();
    translate([le_maker_k,10,0])
        support();

    translate([-10,60,0])
        support();
    translate([le_maker_k,60,0])
        support();
}

module supporters_rpi()
{
    translate([-10,10,0])
        support();
    translate([le_maker_k,10,0])
        support();

    translate([-10,60,0])
        support();
    translate([le_maker_k,60,0])
        support();
}



module pillar()
{
    linear_extrude(5)
        circle(d = 3.5, $fn=16);
    linear_extrude(10)
        circle(d = 2.5, $fn=16);
}

module pillar_lemaker()
{
    translate([3.5,3.5,0])
        pillar();
    translate([49+3.5,3.5,0])//rpi
        pillar();
    translate([3.5,le_maker_w-3.5,0])
        pillar();
    translate([le_maker_k-3.5, le_maker_w-3.5,0])
        pillar();
}

module floor_lemaker()
{
    difference()
    {
        cube([le_maker_k, le_maker_w, 1.5]);
        
        translate([35,60,2])
            cube([30,30,10], center=true);
    }
}


module pillar_rpi()
{
    translate([3.5,3.5,0])
        pillar();
    translate([49+3.5,3.5,0])//rpi
        pillar();
    translate([3.5,58+3.5,0])
        pillar();
    translate([49+3.5, 58+3.5,0])
        pillar();
}

module floor_rpi()
{
    difference()
    {
        cube([le_maker_k, le_maker_w, 1.5]);
        
        translate([35,40,2])
            cube([30,30,10], center=true);
    }
}

pillar_lemaker();
floor_lemaker();

//supporters_potato();
//translate([0,0,5.23])
//    lepotato();

/*

translate([0,0,25])
{
    
    floor_rpi();
    pillar_rpi();
    
    translate([0,0,5]) board_raspberrypi_3_model_b();
    supporters_rpi();
}


translate([0,0,50])
{
    
    floor_rpi();
    pillar_rpi();
    
    translate([0,0,5]) board_raspberrypi_3_model_b();
    supporters_rpi();
}


*/