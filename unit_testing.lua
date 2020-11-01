-- Iterator = dofile("moon_funk.lua")

local Iterator = require "Iterator" 

describe("Skip", function()
    it("Skip positive", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:skip(2):sum()
        assert(res == 12)
    end)

    it("Skip zero", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:skip(0):sum()
        assert(res == 15)
    end)

    it("Skip negative", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:skip(-1):sum()
        assert(res == 15)
    end)
end)

describe("Sum", function()
    it("Sum non-empty", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:sum()
        assert(res == 15)
    end)

    it("Sum Empty", function ()
        t = { }
        iter = Iterator.new(t)
        res = iter:sum()
        assert(res == 0)
    end)
end)
