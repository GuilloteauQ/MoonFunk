require("moon_funk")

t = {1, 2, 3, 4, 5}

iter = Iterator:new(t)

print(iter:map(function(x) return x * x end)
          :filter(function(x) return x % 2 == 1 end)
          :sum())

t = {1, 2, 3, 4, 5}

iter = Iterator:new(t)

print(iter:skip(2):sum())
