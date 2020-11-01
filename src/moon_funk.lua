--- summary.
-- Module for functional operations in Lua
--
local Iterator = {}
Iterator.__index = Iterator

local id = function(x, _) return x, true; end

--- Return a new Iterator on the data
-- @param data some data in a table
-- @return an Iterator on the data
-- @usage local iter = Iterator.new({1, 2, 3, 4, 5})
function Iterator.new(data)
    local ret = {data = data, f = id}
    setmetatable(ret, Iterator)
    return ret
end

--- Applies a function on a iterator
-- @param map_f the function to apply on the elements of the iterator
-- @return the modified iterator
-- @usage iter:map(function(x) return x * x end)
function Iterator:map(map_f)
    local old_f = self.f
    self.f = function(x)
        local fx, b = old_f(x)
        local new_result = b and map_f(fx) or fx
        return new_result, b
    end
    return self
end

function Iterator:fold(fold_f, init)
    local state = init
    local fold_state_f = function(x)
        state = fold_f(x, state)
    end
    local old_f = self.f
    self.f = function(x)
        local fx, b = old_f(x)
        if b then
            fold_state_f(fx)
        end
        return state, b
    end
    return self
end

function Iterator:max()
    self:fold(function(x, s) return x < s and s or x end, -math.huge)
    local t = self:consume()
    return t[#t]
end

function Iterator:min()
    self:fold(function(x, s) return x > s and s or x end, math.huge)
    local t = self:consume()
    return t[#t]
end

function Iterator:filter(filter_f)
    local old_f = self.f
    self.f = function(x)
        local fx, b = old_f(x)
        return fx, b and filter_f(fx)
    end
    return self
end

function Iterator:count()
    return self:map(function(_) return 1 end):sum()
end

function Iterator:enumerate()
    local old_f = self.f
    local state = 0
    self.f = function(x)
        local fx, b = old_f(x)
        if b then
            state = state + 1
            return {i = state, e = fx}, b
        else
            return fx, b
        end
    end
    return self
end

function Iterator:find(x)
    for _, v in ipairs(self.data) do
        local fv, b = self.f(v)
        if b and fv == x then
            return fv
        end
    end
    self.data = nil
    return nil
end

function Iterator:consume()
    local t = {}
    local count = 1
    for _, v in ipairs(self.data) do
        local fv, b = self.f(v)
        if b then
            t[count] = fv
            count = count + 1
        end
    end
    self.data = nil
    return t
end

function Iterator:sum()
    self:fold(function(x, s) return s + x end, 0)
    local t = self:consume()
    return t[#t] ~= nil and t[#t] or 0
end

function Iterator:skip(n)
    local remaining_to_skip = n
    local old_f = self.f
    self.f = function(x)
        local fx, b = old_f(x)
        remaining_to_skip = remaining_to_skip - 1
        return fx, (remaining_to_skip < 0 and b)
    end
    return self
end


-- TODO: there is probably  a beeter way to do it
-- we could change the signature of f to take 2 args
-- there might be some issue if the size (before filter)
-- are not the same (or will need to fix it with states
-- everywhere ...)
function Iterator:zip(other)
    local t_zip = { }
    local t_self = self:consume()
    local t_other = other:consume()
    assert(#t_self == #t_other)

    for i = 1, #t_self do
        t_zip[i] = {t_self[i], t_other[i]}
    end
    self.data = t_zip
    self.f = id
    return self
end

function Iterator:product(other)
    local t_prod = { }
    local t_self = self:consume()
    local t_other = other:consume()

    for i = 1, #t_self do
        for j = 1, #t_other do
            t_prod[i] = {t_self[i], t_other[j]}
        end
    end
    self.data = t_prod
    self.f = id
    return self
end

return Iterator
