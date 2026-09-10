# Plates

Parametric OpenSCAD design for open-bottom, closed-top rectangular test boxes with thick, rounded-corner walls — used for checking print footprints at different sizes.

## How it works

- `rounded_box(w, l, h, r)` builds a rounded rectangular prism by hulling four corner circles and extruding the result to height `h`.
- `footprint_box(w, l, h)` subtracts a slightly smaller, correspondingly-rounded cavity from that shape. The cavity is open at the bottom and stops short of the top, leaving a solid top plate (`top_t`) and solid side walls (`wall`).
- The `sizes` array lists `[w, l, h]` dimensions (mm) for each box to generate. A loop lays the boxes out side by side along X, separated by `gap`.

## Parameters

| Variable   | Meaning                                                   |
|------------|------------------------------------------------------------|
| `wall`     | Side wall thickness, mm                                    |
| `top_t`    | Top surface thickness, mm                                  |
| `corner_r` | Outer corner rounding radius, mm (must be > `wall` for the inside corners to round too) |
| `gap`      | Spacing between boxes, mm                                   |
| `sizes`    | List of `[w, l, h]` box dimensions in mm                    |

## Current sizes

- 5 x 5 x 1.5 cm (active)
- 10 x 10 x 1.5 cm (commented out)
- 20 x 20 x 1.5 cm (commented out)

## Joints (`joint.scad`)

A snap-fit connector that joins two plates along their vertical walls, holding
them at a fixed angle. Each joint is one printed part with a flange + barbed
tab on each end; the tab pushes through a slot cut in the wall (see
`wall_slot_cut` / `joint_slot_w` / `joint_slot_h` in `plates.scad`) and the
barb springs out behind it to lock in place — no glue needed.

Three variants are provided, set by `fold_deg`:

- `0°` — a straight coupler; the joined plates stay flat/coplanar.
- `30°` and `45°` — the bridge between the two tabs is bent, so once both
  tabs are snapped in, the plates end up open at that angle to each other.

`joint.scad` has two output modes (`render_mode` at the bottom of the file):

- `"print"` (default) — lays out all three joints side by side, ready to slice.
- `"demo"` — renders one plate pair + a joint at `demo_fold` degrees, useful
  for checking alignment before printing.

### Tuning the fit

Snap-fit clearances are printer-dependent. If a tab is too tight/loose,
adjust `fit_clear` (per-side clearance) and `barb_h` (retention overhang) in
`joint.scad` and re-print. `wall`, `slot_w`, and `slot_h` in `joint.scad` must
match `wall`, `joint_slot_w`, and `joint_slot_h` in `plates.scad`.

Uncomment entries in `sizes` to generate the additional boxes.
