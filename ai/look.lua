
-- Bot vision and target detection system

-- Initialize bot vision settings
function InitializeVision()
    fieldOfView = 90   -- Field of view in degrees
    detectionRange = 1000 -- Maximum detection range in units
    visionAccuracy = 0.8  -- Probability to correctly identify a target
end

-- Function to check if the bot sees a target
function CanSeeTarget(botID, targetID)
    local botPosition = GetBotPosition(botID)
    local targetPosition = GetTargetPosition(targetID)

    -- Calculate the distance between bot and target
    local distance = CalculateDistance(botPosition, targetPosition)
    
    -- Check if target is within detection range
    if distance > detectionRange then
        return false
    end

    -- Check if the target is within the bot's field of view
    local angleToTarget = CalculateAngleToTarget(botPosition, targetPosition)
    if math.abs(angleToTarget) > fieldOfView / 2 then
        return false
    end

    -- Apply vision accuracy (e.g., fog, distraction, etc.)
    if math.random() > visionAccuracy then
        return false
    end

    return true
end

-- Calculate distance between two positions
function CalculateDistance(pos1, pos2)
    local dx = pos2.x - pos1.x
    local dy = pos2.y - pos1.y
    local dz = pos2.z - pos1.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Calculate the angle to the target
function CalculateAngleToTarget(botPosition, targetPosition)
    local dx = targetPosition.x - botPosition.x
    local dy = targetPosition.y - botPosition.y
    return math.deg(math.atan2(dy, dx))
end
