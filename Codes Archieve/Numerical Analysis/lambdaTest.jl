struct Point{Type <: Real}
    x :: Type
    y :: Type
    z :: Type
end

function norm(p :: Point{T} where T <: Real)::Real
    sqrt(p.x^2 + p.y^2 + p.z^2)
end

function getDistTo(p1 :: Point{T}, p2 :: Point{T}) where {T <: Real}
    return Point(p2.x - p1.x, p2.y - p1.y, p2.z - p1.z)
end

p1 = Point(1, 2, 3)
p2 = Point(1, 2, 5)
print(norm(getDistTo(p1, p2)))