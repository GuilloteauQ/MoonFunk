local Iterator = require 'moon_funk'


local Point = { }
Point.__index = Point

function Point.new(x, y)
    ret = {x = x, y = y}
    setmetatable(ret, Point)
    return ret
end

function Point:dist(p)
    return math.sqrt((self.x - p.x)^2 + (self.y - p.y)^2)
end

Point.__eq = function(p1, p2)
    return p1.x == p2.x and p1.y == p2.y
end



function random_points(n)
    local t = { }
    for i = 1, n do
        local x = math.random(-500, 500)
        local y = math.random(-500, 500)
        t[i] = Point.new(x, y)
    end
    return t
end

local n = 10000

local points = random_points(n)


-- Max Distance
iter1 = Iterator.new(points)
iter2 = Iterator.new(points)

print("Max Distance: " .. iter1:product(iter2)
                               :filter(function(c) return c[1] ~= c[2] end)
                               :map(function(c) return c[1]:dist(c[2]) end)
                               :max())

-- Min Distance
iter1 = Iterator.new(points)
iter2 = Iterator.new(points)

print("Min Distance: " .. iter1:product(iter2)
                               :filter(function(c) return c[1] ~= c[2] end)
                               :map(function(c) return c[1]:dist(c[2]) end)
                               :min())

