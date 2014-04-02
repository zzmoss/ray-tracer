include("types.jl")
rayTracerProperties = {  "lightSource" => Vector(0, 0, -120) ,
		"cameraPos" => Vector(0, 0, 30),
		"objects" => [Sphere( Vector(4,4,-10), 2, Vector(200,255,0)),
		            Sphere( Vector(2,8,-10), 1, Vector(220,0,100)),
			    Sphere( Vector(10,4,-10), 3, Vector(0,100,205))],
		"imageWidth" => 500,
		"imageHeight" => 500,
		"pixelWidth" => 45,
		"imageProperties" => {"colordim" => 1, "colorspace" => "RGB",
		                "spatialorder" => ["x","y"], "limits" => (0x00,0xff)},
		"ambient" => 0.1,
		"specular" => Vector(0, 80, 50)}
	
