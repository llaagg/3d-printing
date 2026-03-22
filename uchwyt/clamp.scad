// Sturdy desk clamp with threads
// Using threads.scad library - download from https://github.com/rcolyer/threads-scad
use <threads.scad>



//translate([-10,-20,0])
//    MetricBoltSet(6, 10, 1);


//ScrewHole(6,10)
//    translate([-5,-5,0])
//    cube(10,10);

$fn=32;


module hole(b, box_w=10, w=6){
    h = b*box_w;
    ScrewHole(w,h, position=[0,0,-h/2,]  )
        children();
}


module ob(v, box_w=10, m=0.1){
    r=box_w*m ;
    translate([
         v[0] * r/2 
        ,v[1] * r/2  
        ,v[2] * r/2
        ])
        children();
}

module sa(mx,my,mz,o=1, m=0.3, box_w=10)
{
    r = box_w * m;
    
    translate(
    [
        -mx/2  ,
        -my/2  ,
        -mz/2  ] )
    sphere(d=r);
};

// how many modules across size x,y,z
// box_d - box dimensions
module box(x,y,z, box_w=10, m=0.5){
   
    t_x = box_w *x;
    t_y = box_w *y;
    t_z = box_w *z;
    r = box_w * m;
    hull()
    {
        /*cube([
            t_x - r, 
            t_y - r, 
            t_z - r
            ], center = true);*/
        ob([1,1,1], m=m, box_w=box_w) sa(t_x, t_y, t_z, m=m, box_w=box_w);
        
        ob([1,-1,1], m=m, box_w=box_w) sa(t_x, -t_y, t_z, ,m=m, box_w=box_w);
        ob([-1,1,1], m=m, box_w=box_w) sa(-t_x, t_y, t_z, ,m=m, box_w=box_w);
        ob([-1,-1,1], m=m, box_w=box_w) sa(-t_x, -t_y, t_z, m=m, box_w=box_w);

        ob([1,1,-1], m=m, box_w=box_w) sa(t_x, t_y, -t_z, m=m, box_w=box_w);
        ob([1,-1,-1], m=m, box_w=box_w) sa(t_x, -t_y, -t_z, ,m=m, box_w=box_w);
        ob([-1,1,-1], m=m, box_w=box_w) sa(-t_x, t_y, -t_z, ,m=m, box_w=box_w);
        ob([-1,-1,-1], m=m, box_w=box_w) sa(-t_x, -t_y, -t_z, m=m, box_w=box_w);
        
    }
}

module mv(v, box_w=10){
    translate([v[0]*box_w, v[1]*box_w, v[2]*box_w])
        children();
}

module oneHLeg(base, w=1)
{
    
    //hole(1)
    mv([-2,0,0])
    hole(1, w = 12)
    mv([-2,0,0])
    hole(1, w = 12)
    mv([2,0,0])
        box(base,w,1); 

}

module clamp(base=5, h = 3, boxd=10)
{
    box(1,3,h,      box_w=boxd);

    mv([0,0,h/2])   oneHLeg(base, 3);

    
    mv([0,0,-h/2])  oneHLeg(base, 3);
    
    
}

include <screw.scad>

//screw(2,bx=20, stw=12);

//translate([20,0,0]) ballCatcher(4);
clamp();