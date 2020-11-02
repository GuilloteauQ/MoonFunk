--- MoonFunk
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

--- Fold the content of the iterator
-- @param fold_f folding function (element, state) -> new state
-- @param init the initial state
-- @return the folded iterator
-- @usage iter:fold(function(x, s) return x + s end, 0)
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

--- Get the maximum value of the iterator
-- @return the maximum value of the data
-- @usage local max = iter:max()
function Iterator:max()
    self:fold(function(x, s) return x < s and s or x end, -math.huge)
    local t = self:consume()
    return t[#t]
end

--- Get the minimum value of the iterator
-- @return the minimum value of the data
-- @usage local min = iter:min()
function Iterator:min()
    self:fold(function(x, s) return x > s and s or x end, math.huge)
    local t = self:consume()
    return t[#t]
end


--- Get the maximum of the iterator based on a comparison function
-- @param f the mapping function
-- @return the element of the iterator that produces the bigger value when applied f
-- @usage local max_by_abs = iter:max_by_key(math.abs)
function Iterator:max_by_key(f)
   self:map(function(x) return {x, f(x)} end)
       :fold(function(x, s) return x[2] < s[2] and s or x end, {nil, -math.huge})
   local t = self:consume()
   return t[#t] ~= nil and t[#t][1] or nil
end

--- Get the minimum of the iterator based on a comparison function
-- @param f the mapping function
-- @return the element of the iterator that produces the smaller value when applied f
-- @usage local min_by_abs = iter:min_by_key(math.abs)
function Iterator:min_by_key(f)
   self:map(function(x) return {x, f(x)} end)
       :fold(function(x, s) return x[2] > s[2] and s or x end, {nil, math.huge})
   local t = self:consume()
   return t[#t] ~= nil and t[#t][1] or nil
end

--- Filter the element of the iterator
-- @param filter_f function returning a boolean to filter the iterator
-- @return iterator with only the value returning true to the filtering function (filter_f)
-- @usage local even_values = iter:filter(function(x) return x % 2 == 0 end):consume()
function Iterator:filter(filter_f)
    local old_f = self.f
    self.f = function(x)
        local fx, b = old_f(x)
        return fx, b and filter_f(fx)
    end
    return self
end

--- Return the number of elements in the iterator
-- @return the number of elements in the iterator
-- @usage local nb_even_elements = iter:filter(function(x) return x % 2 == 0 end):count()
function Iterator:count()
    return self:map(function(_) return 1 end):sum()
end

--- Assocaite every element of the iterator with its rank
-- @return the iterator with every elemnent associated with its rank
-- @usage iter:enumerate()
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


--- Find the elemennt in the iterator
-- Also consume the iterator
-- @param x the element to find in the iterator
-- @return the element in if found, nil otherwise
-- @usage if iter:find(x) then print("found !") end
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

--- Return the table from the iterator
-- @return table with the values of the iterator
-- @usage local result_table = iter:consume()
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

--- Computer the sum of the elements of the iterator
-- @return sum of the element of the irerator
-- @usage local sum = iter:sum()
function Iterator:sum()
    self:fold(function(x, s) return s + x end, 0)
    local t = self:consume()
    return t[#t] ~= nil and t[#t] or 0
end

--- Skip the first n elements of the iterator
-- @param n the number of elements to skip
-- @return the iterator without the first n elements
-- @usage iter:skip(10)
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
