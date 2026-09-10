# Atomic Design Base Panel

`atomic_design_reference_box.scad` is the joinable base panel for the atomic design system.

It is a sturdy, open-top hollow panel intended as a printable reference unit and building block for future designs. Panels connect edge-to-edge on their flat bottom surfaces with a vertical pin hinge. They can stay in one flat plane or rotate around each joint to create angled shapes.

## Dimensions

- Outer width: 50 mm
- Outer depth: 50 mm
- Overall height: 15 mm
- Outer corner radius: 5 mm
- Wall thickness: 3 mm
- Bottom thickness: 3 mm
- Nominal panel pitch: 50 mm

## Design Features

- Flat top rim and flat bottom surface
- Hollow interior to reduce material use
- Rounded outside corners for safer handling and cleaner printing
- Solid bottom and 3 mm walls for stiffness
- Open top for access to the interior
- Male hinge knuckle on the right edge
- Two female hinge knuckles on the left edge
- Replaceable vertical hinge pin

## Joining Panels

Place the flat bottom surfaces on the same work surface, then bring the right edge of one panel against the left edge of the next panel. The male knuckle fits between the two female knuckles. Insert a 3.2 mm diameter pin through the aligned hinge holes. The joint rotates around the vertical pin axis, allowing the panels to remain flat or form straight, angled, and folded arrangements.

The 50 mm panel pitch is the layout unit. Four panels arranged in a straight run use four units for a nominal total width of 200 mm. The hinge barrels overlap at the shared boundaries and are part of the joint, rather than adding another panel unit.

Print the panel flat with the open side facing upward. Print the hinge pin separately with a small clearance from the hinge hole.

## Sample Assembly

`sample_four_panel_angle.scad` shows four panels joined in one connected design. The sample uses 35 degree and -35 degree joint rotations while keeping all panels flat in the Z direction. Open this file in OpenSCAD to preview how the panels can change direction around their vertical hinge pins.

## Modular Panel Reference

`d.scad` is a parametric version of the modular panel system shown in the design reference. It includes:

- Small panel: 50 x 50 x 15 mm
- Medium panel: 100 x 100 x 15 mm
- Large panel: 250 x 250 x 15 mm
- Hollow shells with 2 mm perimeter walls only
- Open top and underside with no solid base or skin
- Internal support ribs on a 25 mm grid
- Alternating male and female dovetail connectors on the edges

Set the `preview` value near the bottom of `d.scad` to `"small"`, `"medium"`, `"large"`, or `"four_small"` before opening it in OpenSCAD. The connector pattern uses a 25 mm grid so panels can be combined into larger flat surfaces or arranged into angled and wave-like structures.

The model is centered on the XY footprint and extends from `-7.5 mm` to `+7.5 mm` on the Z axis. Open the `.scad` file in OpenSCAD to preview or export it for 3D printing.
