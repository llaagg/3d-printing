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

Uncomment entries in `sizes` to generate the additional boxes.
