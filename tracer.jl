include("vector.jl")
import Images
import ImageView

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

## Constants ##
AMBIENT = 0.1

## Method to calculate the Intersection of a ray on a sphere ##
function intersection(s::Sphere, l::Ray)
	v = dot(l.direction, (l.origin - s.center))
	disc = v ^ 2 - ( (dot(l.origin - s.center, l.origin - s.center) - s.radius ^ 2) * dot(l.direction, l.direction))  
	if disc < 0
		return Intersection(Vector(), -1, Vector(), s)
	else
		d = sqrt(disc)
		d1 = (-v + d)
		d2 = (-v - d)
		if 0 < d1 < d2
			point = l.origin + (l.direction * d1)
			distance = d1
		elseif 0 < d2 < d1
			point = l.origin + (l.direction * d2)
			distance = d2
		end
		return Intersection(point, distance, normal(point - s.center), s)
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
		return Vector(255, 255, 255) * AMBIENT
	end
	return intersect.object.color * (1 - AMBIENT) * shade
end

function getReflectedRay(l::Ray, intersect)
	rayDir = l.direction
	normal = intersect.object.normal
	c1 = -dot(rayDir, normal)
	return rayDir + ( rayDir * ( 2 * c1) ) 
end

function traceRayRecursive(l::Ray, lightSource, intersect, recDepth)
	if recDepth > 0
		pointColor = findColor(l, intersect, lightSource)
		reflectedColor =  traceRayRecursive(getReflectedRay(l, intersect), lightSource, intersect, recDepth - 1)
	else
		return pointColor + reflectedColor
	end	
end

function traceRay(l::Ray, lightSource, objects)
	intersect = findIntersection(l, objects)
	if intersect.object == nothing
		return Vector(255, 255, 255) * AMBIENT 
	end
	return findColor(l, intersect, lightSource)
end


## Define Lights and Camera ##
lightSource = Vector(0, 0, -120)
cameraPos = Vector(0,0,30)


## Define objects ##
s1 = Sphere( Vector(4,4,-10), 2, Vector(200,255,0))
s2 = Sphere( Vector(2,8,-10), 1, Vector(220,0,100))
s3 = Sphere( Vector(10,4,-10), 3, Vector(0,100,205))
objects = [s1, s2, s3]
imArray = fill(0xe5, (3, arSize, arSize))
imProperties = {"colordim" => 1, "colorspace" => "RGB", "spatialorder" => ["x","y"], "limits" => (0x00,0xff)}

img = Images.Image(imArray, imProperties)

for i in 1:arSize
	for j in 1:arSize
		ray = Ray(cameraPos, normal(Vector((i-0.5)/45, (j-0.5)/45, 0) - cameraPos))
		col = traceRay(ray, lightSource, objects)
		#println(col)
		imArray[1, i, j] = uint8(col.x)
		imArray[2, i, j] = uint8(col.y)
		imArray[3, i, j] = uint8(col.z)

	end
end

img.data = imArray
