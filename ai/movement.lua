
-- Bot movement and pathfinding logic

-- Initialize movement settings
function InitializeMovement()
    maxSpeed = 300      -- Maximum movement speed
    acceleration = 10   -- Acceleration rate
    deceleration = 15   -- Deceleration rate
    jumpHeight = 50     -- Maximum jump height
end

-- Function to move the bot to a specified position
function MoveToPosition(botID, position)
    local botPosition = GetBotPosition(botID)
    
    -- Calculate the direction to the target position
    local direction = CalculateDirection(botPosition, position)

    -- Apply acceleration or deceleration based on distance
    local distance = CalculateDistance(botPosition, position)
    if distance > 50 then
        Accelerate(botID, direction)
    else
        Decelerate(botID)
    end
end

-- Function to calculate direction towards the target
function CalculateDirection(currentPos, targetPos)
    local dx = targetPos.x - currentPos.x
    local dy = targetPos.y - currentPos.y
    return { x = dx, y = dy }
end

-- Accelerate the bot towards the target
function Accelerate(botID, direction)
    -- Increase bot speed in the given direction
    local currentSpeed = GetBotSpeed(botID)
    local newSpeed = math.min(currentSpeed + acceleration, maxSpeed)
    SetBotSpeed(botID, newSpeed)
    SetBotDirection(botID, direction)
end

-- Decelerate the bot to stop or slow down
function Decelerate(botID)
    local currentSpeed = GetBotSpeed(botID)
    local newSpeed = math.max(currentSpeed - deceleration, 0)
    SetBotSpeed(botID, newSpeed)
end

-- Function to make the bot jump
function Jump(botID)
    -- Check if the bot can jump based on surroundings
    if CanJump(botID) then
        ApplyJumpForce(botID, jumpHeight)
    end
end
