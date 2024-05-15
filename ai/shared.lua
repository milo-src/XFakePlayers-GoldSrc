-- Returns true with a probability of Percent (0-100)
function Chance(Percent)
    return math.random(100) < Percent
end

-- Returns the current time in milliseconds
function Ticks()
    return os.clock() * 1000
end

-- Returns the difference in milliseconds between the current time and ATicks
function DeltaTicks(ATicks)
    return Ticks() - ATicks
end
