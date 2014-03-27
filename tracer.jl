include("vector.jl")

type Ray
	origin::Vector
	direction::Vector
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

## Method to calculate the Intersection of a ray on a sphere ##
## Follows pseudocode from https://www.cs.unc.edu/~rademach/xroads-RT/RTarticle.html ##
function intersection(s::Sphere, l::Ray)
	v = dot(l.direction, (l.origin - s.center))
	disc = s.radius ^ 2 - (dot(l.origin - s.center, l.origin - s.center) - v ^ 2)
	if disc < 0
		return Intersection(Vector(), -1, Vector(), s)
	else
		d = sqrt(disc)
		p = l.origin + (l.direction * (v - d))
		return Intersection(p, d, normal(p - s.center), s)

	end
end

## Method to calculate Intersection of a ray on a plane ##
function intersection(p::Plane, l::Ray)
	v = dot(l.direction, p.normal)
	if v == 0
		return Intersection(Vector(), -1, Vector(), p)
	else
		d = dot(p.point - l.origin, p.normal) / v
		return Intersection (l.origin + (l.direction * d), d, p.normal, p)
	end
end



r = Ray(Vector(0, 1, 2), Vector(1, 1, 1))
s = Sphere(Vector(0, 0, 0), 5, Vector(255, 255, 255))
p = Plane( Vector(0,0,-12), Vector(0,0,1), Vector(255,255,255))
println(intersection(p, r))
