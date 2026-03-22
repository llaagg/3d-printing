

w=  100; //mm
l = 200;
h=  75; //mm

m = 1;

difference()
{
    cube([w, l, h], center = true);
    translate([0,0,m]) cube([w- m, l - m, h - m], center=true);
}