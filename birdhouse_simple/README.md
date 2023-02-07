# Simple Birdhouse
A deliberately very simple birdhouse based on dimensions specified by [earthdesign](http://www.earthdesign.ca/bime.html). One design file supports four different dimensions of birdhouse and it's easy to configure more.

The birdhouse can be mounted to your wood fence. It's deliberately sloped forward by 10 degrees and has small holes for ventilation and drainage. It does not (currently) have a perch.

## Requirements
* 3D printer, obviously. I used a Creality Ender 3 S1 Pro running Klipper. Your print bed size will limit what birdhouses you can print. Mine will handle the chickadee, finch, and sparrow configurations but is too small for swallows.
* Filament. Probably PETg or ASA, though PLA may work in a pinch. Remember, you'll probably be mounting the birdhouse outdoors where it will be subject to weather and to UV
* Six M5x20 screws, for attaching the parts together
* Three M5x25 wood screws, for attaching the birdhouse to your wood fence
* [OpenSCAD](https://openscad.org/), if you wish to modify the birdhouse

## How to Print and Mount
Note that I've only actually printed the birdhouse for chickadees. However, the point of the design is that it is parameterised, allowing for different bird types.

Consider printing `birdhouse_screw_test.stl` to ensure you'll be able to screw together your final result. If that doesn't work, you can tweak the settings in the OpenSCAD design file.

Using your filament of choice (likely, PETg), print each of the three corresponding `STL` files. For example, `birdhouse_chickadee_roof.stl`, `birdhouse_chickadee_body.stl`, and `birdhouse_chickadee_attachment.stl`. I used a layer height of 20 and cubic subdivision for infill, 25% for the attachment and 20% for the other two files.

Attach the roof to the body using three M5x20 screws.

Next, before you connect the attachment to the body, use your three M5x25 wood screws to mount the attachment on your fence.

Finally, mount the birdhouse to the attachment with your remaining three M5x20 screws.

Now, wait for the bird family to move in!

## How to Tweak
The design is parameterised. Open the file in OpenSCAD and take a look at the top. You can change the bird type, tune your wall thickness, modify your screw tolerance, even change the slope angle. Note that you'll want to verify any changes haven't broken the resulting render. I welcome bug fixes!

If you have changed the parameters, you can generate STL files by scrolling to the bottom of the file and uncommenting each of the three parts, then rendering ('F6') and exporting to STL ('F7'). When printed individually, the parts should be rendered in the rotation most suitable for 3d printing.

## License

See LICENSE.TXT. This code is licensed under CC-BY-SA-4.0. That license allows
for private use, modification, distribution, and even commercial use (for
example, feel free to print and sell the birdhouse), so long as you provide
attribution. See the license for details.

-- Chris Thompson
