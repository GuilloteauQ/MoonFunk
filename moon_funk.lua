Iterator = {}
Iterator.__index = Iterator


local id = function(x, b) return x, true; end

function Iterator:new(data)
    local ret = {data = data, f = id}
    setmetatable(ret, Iterator)
    return ret
end

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
    return self:map(function(x) return 1 end):sum()
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
    for i, v in ipairs(self.data) do
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
    for i, v in ipairs(self.data) do
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
    return t[#t]
end

function print_table(t)
    for i, v in ipairs(t) do
        io.write(v .. " ")
    end
    io.write("\n")
end
