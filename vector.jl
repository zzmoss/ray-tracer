import Base.cross, Base.dot

type Vector
	x::Real
	y::Real
	z::Real
end

## Outer Constructors ##

Vector() = Vector(0, 0, 0)

## Methods on Vector ##

function toList(a::Vector)
	return [a.x, a.y, a.z]
end

function toVec(a::Array)
	return Vector(a[1], a[2], a[3])
end

function +(a::Vector, b::Vector)
	return toVec(toList(a) + toList(b))
end

function -(a::Vector, b::Vector)
	return toVec(toList(a) - toList(b))
end

function *(a::Vector, b::Real)
	return toVec(toList(a) * b)
end

function magnitude(a::Vector)
	return sqrt(a.x ^ 2 + a.y ^ 2 + a.z ^ 2)
end

function normal(a::Vector)
	mag = magnitude(a)
	return toVec(toList(a) / mag)
end

function dot(a::Vector, b::Vector)
	return dot(toList(a), toList(b))
end

function cross(a::Vector, b::Vector)
	return toVec(cross(toList(a), toList(b)))
end

