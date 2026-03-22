// Screw and related helper modules moved from clamp.scad

module screw(sh=2, bx=10, stw=12)
{
    st = 6;
    h = sh * 10;
    bh = bx/2; // base height
    translate([0,0,bh])
    {
        ScrewThread(st,h);
        translate([0,0, h+bh/2 -1 ])
            sphere(d=st-2);
    }
    translate([0,0,bh/2])
    cube([bx,bx,bh], center=true);
}


// h - ball radius
// ew - width of hand
module ballCatcher_bcHand(h=10, ew=2)
{
     rotate([90,0,0])
        linear_extrude(1, center = true)
            polygon(
                points=
                [
                    [h * 0.15 ,0],
                    [h * 0.4, h * 0.25],
                    [h * 0.5, h * 0.5],
                    [h * 0.4, h * 0.75],
                    [h * 0.6, h * 0.75],
                    [h * 0.6, h * 0.0],
                ]
            );
}

// br - ball radius
module ballCatcher(br=6)
{
    howMany = 8;
    ew = 2;
    bh=2;

    translate([0,0,bh])
    {
        for(i = [0: 360/howMany : 360])
        {
            rotate([0,0,i])
                ballCatcher_bcHand(br, ew);
        }
    }

    linear_extrude(bh)
        circle(d = br + ew);
}
