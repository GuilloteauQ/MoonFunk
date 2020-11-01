# MoonFunk

Basic Functional Operations in Lua

## Example

Let us compute the sum of the squares of even values:

```lua
local t = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local iter = Iterator.new(t)
iter:filter(function(x) return x % 2 == 0 end)
    :map(function(x) return x * x end)
    :sum()
```

## Documentation

You can find the documentation [here](https://guilloteauq.github.io/MoonFunk/)
