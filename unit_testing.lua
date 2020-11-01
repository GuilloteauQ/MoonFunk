-- local Iterator = dofile("src/moon_funk.lua")

local Iterator = require "moon_funk" 

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

    it("Skip more than size", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:skip(10):sum()
        assert(res == 0)
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

describe("Fold", function()
    it("Simple Fold", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:fold(function(x, _) return x end, 0):consume()
        assert(res[#res] == 5)
    end)

    it("Sum Fold", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:fold(function(x, s) return x + s end, 0):consume()
        assert(res[#res] == 15)
    end)
end)


describe("Find", function()
    it("In Find", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:find(3)
        assert(res ~= nil)
    end)

    it("Not in Find", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:find(6)
        assert(res == nil)
    end)
end)

describe("Count", function()
    it("Non empty Count", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:count()
        assert(res == 5)
    end)

    it("Empty Count", function ()
        t = { }
        iter = Iterator.new(t)
        res = iter:count()
        assert(res == 0)
    end)

    it("Filtered Count", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:filter(function(x) return x % 2 == 0 end):count()
        assert(res == 2)
    end)
end)

describe("Max/Min", function()
    it("Simple Min", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:min()
        assert(res == 1)
    end)

    it("Complex Min", function ()
        t = {7, 1, 2, 3, 4, 5, 2}
        iter = Iterator.new(t)
        res = iter:min()
        assert(res == 1)
    end)

    it("Empty Min", function ()
        t = { }
        iter = Iterator.new(t)
        res = iter:min()
        assert(res == nil)
    end)

    it("Simple Max", function ()
        t = {1, 2, 3, 4, 5}
        iter = Iterator.new(t)
        res = iter:max()
        assert(res == 5)
    end)

    it("Complex Max", function ()
        t = {2, 1, 2, 3, 4, 5, 2}
        iter = Iterator.new(t)
        res = iter:max()
        assert(res == 5)
    end)

    it("Empty Max", function ()
        t = { }
        iter = Iterator.new(t)
        res = iter:max()
        assert(res == nil)
    end)

    it("Simple Min by key", function ()
        t = {1, -2, 3, -4, 5}
        iter = Iterator.new(t)
        res = iter:min_by_key(math.abs)
        assert(res == 1)
    end)

    it("Complex Min by key", function ()
        t = {-2, -1, -2, -6, -4, 5, -1}
        iter = Iterator.new(t)
        res = iter:min_by_key(math.abs)
        assert(res == -1)
    end)

    it("Empty Min by key", function ()
        t = { }
        iter = Iterator.new(t)
        res = iter:min_by_key(math.abs)
        assert(res == nil)
    end)

    it("Simple Max by key", function ()
        t = {1, -2, 3, -4, 5}
        iter = Iterator.new(t)
        res = iter:max_by_key(math.abs)
        assert(res == 5)
    end)

    it("Complex Max by key", function ()
        t = {-2, -1, -2, -6, -4, 5, -1}
        iter = Iterator.new(t)
        res = iter:max_by_key(math.abs)
        assert(res == -6)
    end)

    it("Empty Max by key", function ()
        t = { }
        iter = Iterator.new(t)
        res = iter:max_by_key(math.abs)
        assert(res == nil)
    end)
end)

