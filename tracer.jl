include("vector.jl")

type Ray
	origin::Vector
	dest::Vector
end

type Sphere
	center::Vector
	radius::Real
	color::Vector
end

type Plane
	normal::Vector
	point::Vector
	color::Vector
end

type Intersection
	point::Vector
	distance::Real
	normal::Vector
	object
end


println(cross(Vector(2, 3, 4), Vector(3, 4, 5)))
println(dot(Vector(2, 3, 4), Vector(3, 4, 5)))

println (Vector(2, 3, 5) + Vector(1, 2, 3))
println (Vector(2, 3, 5) * 3.5)


