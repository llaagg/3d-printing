// Sturdy desk clamp with threads
// Using threads.scad library - download from https://github.com/rcolyer/threads-scad
use <threads.scad>


//ScrewThread(10,10);

//translate([-10,-20,0])
//    MetricBoltSet(6, 10, 1);


//ScrewHole(6,10)
//    translate([-5,-5,0])
//    cube(10,10);

$fn=32;


module hole(b, box_w=10){
    h = b*box_w;
    ScrewHole(6,h, position=[0,0,-h/2,]  )
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

module sa(mx,my,mz,o=1, m=0.1, box_w=10)
{
    r = box_w * m;
    
    translate(
    [
        -mx/2 ,
        -my/2  ,
        -mz/2  ] )
        sphere(d=r);
};

module box(x,y,z, box_w=10, m=0.1){
   
    t_x = box_w*x;
    t_y = box_w*y;
    t_z = box_w*z;
    r = box_w * m;
    hull()
    {
        /*cube([
            t_x - r, 
            t_y - r, 
            t_z - r
            ], center = true);*/
        ob([1,1,1]) sa(t_x, t_y, t_z, m=m, box_w=box_w);
        ob([1,-1,1]) sa(t_x, -t_y, t_z, ,m=m, box_w=box_w);
        ob([-1,1,1]) sa(-t_x, t_y, t_z, ,m=m, box_w=box_w);
        ob([-1,-1,1]) sa(-t_x, -t_y, t_z, m=m, box_w=box_w);

        ob([1,1,-1]) sa(t_x, t_y, -t_z, m=m, box_w=box_w);
        ob([1,-1,-1]) sa(t_x, -t_y, -t_z, ,m=m, box_w=box_w);
        ob([-1,1,-1]) sa(-t_x, t_y, -t_z, ,m=m, box_w=box_w);
        ob([-1,-1,-1]) sa(-t_x, -t_y, -t_z, m=m, box_w=box_w);

    }
}

module mv(v, box_w=10){
    translate([v[0]*box_w, v[1]*box_w, v[2]*box_w])
        children();
}

//translate([-10,-10,-10])box(2,2,2); 

box(1,1,3);

// bottom handle
mv([-2,0,-2])
    hole(1)
    mv([1,0,0])
    box(3,1,1); 

//upper
mv([-2,0,2])
    hole(1)
    mv([1,0,0])
    box(3,1,1); 
