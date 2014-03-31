include("vector.jl")
import Images
import ImageView
import Tk

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

## Constants ##
AMBIENT = 0.1

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

function findIntersection(r::Ray, objects, ignore=nothing)
	intersect = Intersection(Vector(), -1, Vector(), nothing)
	for obj in objects
		if obj != ignore
			newIntersect = intersection(obj, r)
			if intersect.distance < 0 && newIntersect.distance > 0
				intersect = newIntersect
			elseif 0 < newIntersect.distance < intersect.distance
				intersect = newIntersect
			end
		end
	end
	return intersect
end

function findColor(l::Ray, intersect, lightSource)
	shade = dot(intersect.normal, normal(intersect.point - lightSource))
	if(shade <= 0)
		shade = 0
	end
	return intersect.object.color * (1 - AMBIENT) * shade
end

function traceRay(l::Ray, lightSource, objects)
	intersect = findIntersection(l, objects)
	if intersect.object == nothing
		return Vector(255, 255, 255) 
	end
	return findColor(l, intersect, lightSource)
end

## Define Lights and Camera ##
lightSource = Vector(0,10,0)
cameraPos = Vector(0,0,20)


## Define objects ##
s1 = Sphere( Vector(-2,0,-10), 2, Vector(0,255,0))
s2 = Sphere( Vector(2,0,-10), 3.5, Vector(255,0,0))
s3 = Sphere( Vector(0,-4,-10), 3, Vector(0,0,255))
p = Plane( Vector(0,0,-12), Vector(0,0,1), Vector(255,255,255))
objects = [s1, s2, s3, p]
#objects = [p]

img = Images.imread("test.png")
arSize = 500
imArray = fill(0xff, (3, arSize, arSize))


for i in 1:arSize
	for j in 1:arSize
		ray = Ray(cameraPos, normal(Vector(i/45, j/45, 0) - cameraPos))
		#println(ray)
		col = traceRay(ray, lightSource, objects)
		##println(col)
		imArray[1, arSize+1-j, i] = uint8(col.x)
		imArray[2, arSize+1-j, i] = uint8(col.y)
		imArray[3, arSize+1-j, i] = uint8(col.z)
	end
end

img.data = imArray



