include("vector.jl")
include("types.jl")
include("properties.jl")
import Images

## Constants ##
AMBIENT = get(rayTracerProperties, "ambient", 0.1)

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

function blinnPhongShadeColor(l::Ray, intersect, lightSource, camera)
	n = intersect.normal
	l = normal(intersect.point - lightSource)
	v = normal(intersect.point - camera)
	h = (v + l) * (1 / magnitude(v + l))
	kSpecular = get(rayTracerProperties, "specular", Vector())
	kDiffuse = intersect.object.color
	I = 1 - AMBIENT

	return (kDiffuse * I * max(0, dot(n, l))) + (kSpecular * I * max(0, dot(n, h)))
end

function lambertShadeColor(l::Ray, intersect, lightSource)
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
		pointColor = lambertShadeColor(l, intersect, lightSource)
		reflectedColor =  traceRayRecursive(getReflectedRay(l, intersect), lightSource, intersect, recDepth - 1)
	else
		return pointColor + reflectedColor
	end	
end

function traceRay(l::Ray, lightSource, objects, cameraPos)
	intersect = findIntersection(l, objects)
	if intersect.object == nothing
		return Vector(255, 255, 255) * AMBIENT 
	end
	#return lambertShadeColor(l, intersect, lightSource)
	return blinnPhongShadeColor(l, intersect, lightSource, cameraPos)
end


function traceWorker(i, j, imageArray, cameraPos, lightSource, objects)
	ray = Ray(cameraPos, normal(Vector((i-0.5)/45, (j-0.5)/45, 0) - cameraPos))
	col = traceRay(ray, lightSource, objects, cameraPos)
	imageArray[1, i, j] = uint8(col.x)
	imageArray[2, i, j] = uint8(col.y)
	imageArray[3, i, j] = uint8(col.z)
end

function render()
	
	## Read from properties ##
	rtp = rayTracerProperties
	lightSource = get(rtp, "lightSource", Vector())
	cameraPos = get(rtp, "cameraPos", Vector())
	objects = get(rtp, "objects", nothing)
	imageWidth = get(rtp, "imageWidth", 0)
	imageHeight = get(rtp, "imageHeight", 0)
	pixelWidth = get(rtp, "pixelWidth", 0)
	imageProperties = get(rtp, "imageProperties", nothing)

	## Setup image array ##
	imageArray = fill(0x00, (3, imageWidth, imageHeight))

	## Initialize the image ##
	image = Images.Image(imageArray, imageProperties)

	## ImageArray is by reference, will be mutated in traceWorker :( ##
	@parallel for x in 1:imageWidth, y in 1:imageHeight
			traceWorker(x, y, imageArray, cameraPos, lightSource, objects) 
		end
	image.data = imageArray
	return image

end
finalImage = render()
