
type Ray
	origin::Vector
	direction::Vector
end

type Sphere
	center::Vector
	radius::Real
	color::Vector
end

type Intersection
	point::Vector
	distance::Real
	normal::Vector
	object
end
