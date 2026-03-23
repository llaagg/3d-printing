$fn=32;


// box_w - width of the box module (size of one module)
// b - number of modules across the box
// w - width of the hole
// oy - offset in the y direction
module hole(b=1, boxd=10, w=6, oym = 1, top = true){
    h =  b*boxd;
    hm = h * oym;
    y = - (hm/2);


    a = top ? 1 : -1;
    yo = a * (h / 2 - hm / 2);
    of = y + yo;

    ScrewHole(w, hm, position=[0, 0, of]  )
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

module oneHLeg(base, w=1, boxd=10, d=true)
{
    //mv([-0.5,0,0.5])
    mv([-0.5,0,0])
        hole(b=1, w=10, boxd=boxd, oym = 0.5, top = d)
    mv([-1.5,0,0])
        hole(2, w = 10) // element hole
    mv([-1.5,0,0])
        hole(2, w = 10) // clamp mount hole
    mv([1.5,0,0])
        box(base,w,1); 

}

module clamp(base=5, h = 5, boxd=10)
{
    box(1,2,h+1, box_w=boxd);

    mv([0,0, h/2 + 0.5 ]) 
        oneHLeg(base, 2, boxd);

    mv([0,0, -h/2 -0.5 ]) 
        oneHLeg(base, 2, boxd, false);
}
