ray-tracer
==========

Ray Tracer in Julia

This ray tracer renders Spheres on a 2D surface. It uses the Blinn Phong algorithm to shade, and also has code for Lambertian shading.

It uses the https://github.com/timholy/Images.jl library to render the image.

To test the ray-tracer.

##### Install ImageMagick (Dependency for Images.jl)

http://www.imagemagick.org/script/binary-releases.php

http://www.imagemagick.org/script/install-source.php

##### From the project directory run the Julia command line interpreter

##### Within the interpreter, install Images, ImageView packages

``` julia
Pkg.add("Images")
Pkg.add("ImageView")

## To check status ##
Pkg.status()
```

##### To test the ray tracer, within the interpreter:

``` julia
include("tracer.jl")
import ImageView
ImageView.display(finalImage)
```

