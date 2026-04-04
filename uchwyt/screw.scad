// Sturdy desk clamp with threads
// Using threads.scad library - download from https://github.com/rcolyer/threads-scad
use <threads.scad>

// w - width of the screw head 
//    * height of screw nut
//    * half of that is screw cylinder on top
// h - height of the screw bolt
module screw(w=10, h=50, tolerance = 0.4)
{

    MetricBolt(w, h, tolerance = tolerance);

    translate([0 , 0 , 0 + w/4 +  w +h  ])
        cylinder(h= w/2 , d= (w/2)  , center=true);
}


module ballCatcher(w=10)
{
    bc_h = w/2;
    

    difference()
    {
        translate([0, 0, (bc_h/2)+1]) 
            cylinder(h=bc_h+1,  r=w, center=true);
        
        translate([0, 0, bc_h/2]) 
            cylinder(h= w/2 ,   d = (w/2)  , center=true);
    }
    
}

module supporters(h=50, w=10)
{
  
    translate([0,0,0])
    screw(w=w, h=h, tolerance = t);

    // translate([-40,0,0])    
    //     ballCatcher(w=w);

}