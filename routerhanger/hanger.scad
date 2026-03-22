/*linear_extrude(1, center = true)
    polygon(points=[
            [0,0],
            [0,100],
            [45,115],
            [65,115],
            [65,90],
            [63,90],
            [63,112],
            [45,112],
            //[70,90],
            [2,90],
            [2,-2],
            [-33,-2],
            [-33,60],
            [-30,60],
            [-30,0],
            
            
        ]);
 
*/

use <threads.scad>

/*

ScrewHole(5,2,position=[0,0,-1]  )
    translate([75,0,0])
    ScrewHole(5,4,position=[0,0,-1]  )
    translate([-75/2,-0,0])
    cube([100,10,2], center=true);
*/

//MetricBolt(4,6);

module hand()
{
    
    cube([10, 90, 2], center = true);
    
    translate([0,40,2])
    {
        cube([1.2, 1.2, 3], center = true);
        translate([0,0,1])
        {
            linear_extrude(1.2)
                circle(d=4);
        }
    }
}

translate([-50,0,0])
    ScrewHole(4,2,position=[0,0,-1]  )
    translate([100,0,0])
    ScrewHole(4,2,position=[0,0,-1]  )
    translate([-50,0,0])
    cube([110, 10, 2], center=true);

translate([-60,40,0])
    hand();
    
translate([60,40,0])
    hand();

//cube
//cube([127, 85, 1], center=true);

