import Base

struct Point
    x :: Number
    y :: Number
    z :: Number
end

Base.:+(p1 :: Point, p2 :: Point) = Point(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z)

p1 = Point(1, 2, 3)
p2 = Point(1, 2, 4)
p = p1 + p2
print(p)