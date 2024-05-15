-- Vector library for zbots in CS 1.6

-- Define Vec3 class
Vec3 = {}
Vec3.__index = Vec3

-- Constructor for Vec3
function Vec3.New(X, Y, Z)
    return setmetatable({X = X or 0, Y = Y or 0, Z = Z or 0}, Vec3)
end

-- Equality comparison for Vec3
function Vec3.__eq(A, B)
    if type(A) == "number" then
        return A == B.X and A == B.Y and A == B.Z
    elseif type(B) == "number" then
        return A.X == B and A.Y == B and A.Z == B
    else
        return A.X == B.X and A.Y == B.Y and A.Z == B.Z
    end
end

-- Addition operator overload for Vec3
function Vec3.__add(A, B)
    if type(A) == "number" then
        return Vec3.New(A + B.X, A + B.Y, A + B.Z)
    elseif type(B) == "number" then
        return Vec3.New(A.X + B, A.Y + B, A.Z + B)
    else
        return Vec3.New(A.X + B.X, A.Y + B.Y, A.Z + B.Z)
    end
end

-- Subtraction operator overload for Vec3
function Vec3.__sub(A, B)
    if type(A) == "number" then
        return Vec3.New(A - B.X, A - B.Y, A - B.Z)
    elseif type(B) == "number" then
        return Vec3.New(A.X - B, A.Y - B, A.Z - B)
    else
        return Vec3.New(A.X - B.X, A.Y - B.Y, A.Z - B.Z)
    end
end

-- Multiplication operator overload for Vec3
function Vec3.__mul(A, B)
    if type(A) == "number" then
        return Vec3.New(A * B.X, A * B.Y, A * B.Z)
    elseif type(B) == "number" then
        return Vec3.New(A.X * B, A.Y * B, A.Z * B)
    else
        return Vec3.New(A.X * B.X, A.Y * B.Y, A.Z * B.Z)
    end
end

-- Division operator overload for Vec3
function Vec3.__div(A, B)
    if type(A) == "number" then
        return Vec3.New(A / B.X, A / B.Y, A / B.Z)
    elseif type(B) == "number" then
        return Vec3.New(A.X / B, A.Y / B, A.Z / B)
    else
        return Vec3.New(A.X / B.X, A.Y / B.Y, A.Z / B.Z)
    end
end

-- Dot product of two Vec3
function Vec3DotProduct(A, B)
    return (A.X * B.X) + (A.Y * B.Y) + (A.Z * B.Z)
end

-- Length of a Vec3
function Vec3Length(V)
    return math.sqrt(Vec3DotProduct(V, V))
end

-- Unpack Vec3
function Vec3Unpack(V) 
    return V.X, V.Y, V.Z
end

-- String representation of Vec3
function Vec3.__tostring(A)
    return("X: " .. math.floor(A.X) .. ", Y: " .. math.floor(A.Y) .. ", Z: " .. math.floor(A.Z))
end

-- Define Vec2 class
Vec2 = {}
Vec2.__index = Vec2

-- Constructor for Vec2
function Vec2.New(X, Y)
    return setmetatable({X = X or 0, Y = Y or 0}, Vec2)
end

-- Equality comparison for Vec2
function Vec2.__eq(A, B)
    if type(A) == "number" then
        return A == B.X and A == B.Y
    elseif type(B) == "number" then
        return A.X == B and A.Y == B
    else
        return A.X == B.X and A.Y == B.Y
    end
end

-- Addition operator overload for Vec2
function Vec2.__add(A, B)
    if type(A) == "number" then
        return Vec2.New(A + B.X, A + B.Y)
    elseif type(B) == "number" then
        return Vec2.New(A.X + B, A.Y + B)
    else
        return Vec2.New(A.X + B.X, A.Y + B.Y)
    end
end

-- Subtraction operator overload for Vec2
function Vec2.__sub(A, B)
    if type(A) == "number" then
        return Vec2.New(A - B.X, A - B.Y)
    elseif type(B) == "number" then
        return Vec2.New(B.X - A, B.Y - A)
    else
        return Vec2.New(A.X - B.X, A.Y - B.Y)
    end
end

-- Multiplication operator overload for Vec2
function Vec2.__mul(A, B)
    if type(A) == "number" then
        return Vec2.New(A * B.X, A * B.Y)
    elseif type(B) == "number" then
        return Vec2.New(A.X * B, A.Y * B)
    else
        return Vec2.New(A.X * B.X, A.Y * B.Y)
    end
end

-- Division operator overload for Vec2
function Vec2.__div(A, B)
    if type(A) == "number" then
        return Vec2.New(A / B.X, A / B.Y)
    elseif type(B) == "number" then
        return Vec2.New(A.X / B, A.Y / B)
    else
        return Vec2.New(A.X / B.X, A.Y / B.Y)
    end
end

-- Length of a Vec2
function Vec2Length(V)
    return math.sqrt((V.X * V.X) + (V.Y * V.Y))
end

-- String representation of Vec2
function Vec2.__tostring(A)
    return("X: " .. math.floor(A.X) .. ", Y: " .. math.floor(A.Y))
end

-- Define Vec3Line class
Vec3Line = {}
Vec3Line.__index = Vec3Line

-- Constructor for Vec3Line
function Vec3Line.New(HiX, HiY, HiZ, LoX, LoY, LoZ)
    return setmetatable({HiX = HiX or 0, HiY = HiY or 0, HiZ = HiZ or 0, LoX = LoX or 0, LoY = LoY or 0, LoZ = LoZ or 0}, Vec3Line)
end

-- String representation of Vec3Line
function Vec3Line.__tostring(A)
    return("Hi: [X: " .. A.HiX .. ", Y: " .. A.HiY .. ", Z: " .. A.HiZ .. "], Lo [X: " .. A.LoX .. ", Y: " .. A.LoY .. ", Z: " .. A.LoZ .. "]") 
end

-- Calculate center point of Vec3Line
function Vec3LineCenter(A)
    local Lo = Vec3.New(A.LoX, A.LoY, A.LoZ)
    local Hi = Vec3.New(A.HiX, A.HiY, A.HiZ)
    return (Lo + Hi) * 0.5
end

-- Define Vec2Line class
Vec2Line = {}
Vec2Line.__index = Vec2Line

-- Constructor for Vec2Line
function Vec2Line.New(HiX, HiY, LoX, LoY)
    return setmetatable({HiX = HiX or 0, HiY = HiY or 0, LoX = LoX or 0, LoY = LoY or 0}, Vec2Line)
end

-- String representation of Vec2Line
function Vec2Line.__tostring(A)
    return("Hi: [X: " .. A.HiX .. ", Y: " .. A.HiY .. "], Lo [X: " .. A.LoX .. ", Y: " .. A.LoY .. "]") 
end

-- Check if two Vec2Lines intersect in 2D space
function IsVecLinesIntersectedIn2D(A, B)
    local ADX = A.LoX - A.HiX
    local ADY = A.LoY - A.HiY
    
    local BDX = B.LoX - B.HiX
    local BDY = B.LoY - B.HiY
    
    local F1 = ADX * (B.HiY - A.HiY) - ADY * (B.HiX - A.HiX)
    local F2 = ADX * (B.LoY - A.HiY) - ADY * (B.LoX - A.HiX)
    local F3 = BDX * (A.HiY - B.HiY) - BDY * (A.HiX - B.HiX)
    local F4 = BDX * (A.LoY - B.HiY) - BDY * (A.LoX - B.HiX)

    return ((F1 * F2 < 0) and (F3 * F4 < 0))	
end